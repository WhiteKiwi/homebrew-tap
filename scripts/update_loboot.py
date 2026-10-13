#!/usr/bin/env python3
"""Stage a Loboot formula only after verifying every published release asset.

No upstream code is executed. A release may change only the version and hashes
of the reviewed formula; changes to formula behavior require a normal PR.
"""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import sys
import urllib.request

REPOSITORY = "WhiteKiwi/loboot"
SCHEMA = "loboot.release/v1"
TARGETS = (
    "aarch64-apple-darwin",
    "x86_64-apple-darwin",
    "aarch64-unknown-linux-gnu",
    "x86_64-unknown-linux-gnu",
)
VERSION = r"(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)"
MAX_ARCHIVE = 64 * 1024 * 1024
URL_ROOT = f"https://github.com/{REPOSITORY}/releases/download"
LATEST_API = f"https://api.github.com/repos/{REPOSITORY}/releases/latest"


def request_headers(url):
    headers = {"User-Agent": "whitekiwi-tap-loboot-updater"}
    # Use only the job's existing read-scoped token for this exact API request.
    # Asset downloads never receive it, including their redirect destinations.
    if url == LATEST_API and os.environ.get("GITHUB_TOKEN"):
        headers["Authorization"] = "Bearer " + os.environ["GITHUB_TOKEN"]
    return headers


def fetch(url, limit):
    request = urllib.request.Request(url, headers=request_headers(url))
    with urllib.request.urlopen(request, timeout=120) as response:
        data = response.read(limit + 1)
    if len(data) > limit:
        raise ValueError(f"Response exceeds size limit: {url}")
    return data


def version_tuple(value):
    if not isinstance(value, str) or re.fullmatch(VERSION, value) is None:
        raise ValueError("Expected a stable major.minor.patch version")
    return tuple(int(part) for part in value.split("."))


def current_version(formula):
    versions = re.findall(r"/releases/download/v([^/]+)/loboot-v", formula)
    if len(versions) != len(TARGETS) or len(set(versions)) != 1:
        raise ValueError("Reviewed formula must contain exactly four matching release URLs")
    version_tuple(versions[0])
    explicit = re.findall(r'^  version "([^"]+)"$', formula, flags=re.MULTILINE)
    if explicit and explicit != [versions[0]]:
        raise ValueError("Explicit formula version does not match its release URLs")
    return versions[0]


def normalize_formula(formula):
    """Drop only a matching, redundant version line from the first release.

    Homebrew infers the version from URLs and rejects the redundant stanza.
    All other formula bytes remain reviewed and must match exactly.
    """
    version = current_version(formula)
    explicit = re.findall(r'^  version "([^"]+)"$', formula, flags=re.MULTILINE)
    if explicit and version != "0.1.0":
        raise ValueError("Redundant version compatibility is limited to v0.1.0")
    return re.sub(r'^  version "0\.1\.0"\n', '', formula, count=1, flags=re.MULTILINE) if explicit else formula


def release_assets(release):
    if release.get("draft") is not False or release.get("prerelease") is not False:
        raise ValueError("Only published stable releases can update the tap")
    tag = release.get("tag_name", "")
    if not isinstance(tag, str) or not tag.startswith("v"):
        raise ValueError("Expected a v-prefixed stable release tag")
    version_tuple(tag[1:])
    names = [f"loboot-{tag}-{target}.tar.gz" for target in TARGETS]
    required = set(names + ["manifest.json", "SHA256SUMS.txt", "loboot.rb"])
    assets = {}
    for asset in release.get("assets", []):
        name = asset.get("name")
        if name not in required:
            continue
        if name in assets:
            raise ValueError(f"Duplicate release asset: {name}")
        expected_url = f"{URL_ROOT}/{tag}/{name}"
        if asset.get("browser_download_url") != expected_url or asset.get("state") != "uploaded":
            raise ValueError(f"Unexpected or incomplete release asset: {name}")
        size = asset.get("size")
        if not isinstance(size, int) or not 0 < size <= MAX_ARCHIVE:
            raise ValueError(f"Invalid release asset size: {name}")
        digest = asset.get("digest")
        if not isinstance(digest, str) or re.fullmatch(r"sha256:[0-9a-f]{64}", digest) is None:
            raise ValueError(f"Missing or invalid GitHub asset digest: {name}")
        assets[name] = asset
    if set(assets) != required:
        raise ValueError(f"Missing release assets: {sorted(required - assets.keys())}")
    return tag, assets


def manifest_hashes(manifest, tag):
    if manifest.get("schema_version") != SCHEMA or manifest.get("version") != tag[1:]:
        raise ValueError("Manifest schema or version does not match the release")
    hashes = {}
    for artifact in manifest.get("artifacts", []):
        target = artifact.get("target")
        if target not in TARGETS or target in hashes:
            raise ValueError("Unexpected or duplicate manifest target")
        if artifact.get("schema_version") != SCHEMA or artifact.get("version") != tag[1:]:
            raise ValueError("Artifact schema or version does not match the release")
        if artifact.get("archive") != f"loboot-{tag}-{target}.tar.gz":
            raise ValueError("Unexpected archive basename")
        digest = artifact.get("sha256")
        if not isinstance(digest, str) or re.fullmatch(r"[0-9a-f]{64}", digest) is None:
            raise ValueError("Invalid manifest SHA-256")
        hashes[target] = digest
    if set(hashes) != set(TARGETS):
        raise ValueError("Manifest does not contain exactly the four supported targets")
    return hashes


def render_update(formula, tag, hashes):
    formula = normalize_formula(formula)
    previous = current_version(formula)
    for target in TARGETS:
        old_url = f"{URL_ROOT}/v{previous}/loboot-v{previous}-{target}.tar.gz"
        new_url = f"{URL_ROOT}/{tag}/loboot-{tag}-{target}.tar.gz"
        pattern = re.compile(r'(url ")' + re.escape(old_url) + r'("\n\s+sha256 ")[0-9a-f]{64}(")')
        formula, count = pattern.subn(lambda m: m[1] + new_url + m[2] + hashes[target] + m[3], formula)
        if count != 1:
            raise ValueError(f"Expected one reviewed URL/hash pair for {target}")
    return formula


def verify_release(release, formula, downloader=fetch):
    tag, assets = release_assets(release)

    def download(name, limit):
        asset = assets[name]
        data = downloader(asset["browser_download_url"], limit)
        if len(data) != asset["size"]:
            raise ValueError(f"Asset size mismatch: {name}")
        digest = asset.get("digest")
        if digest != "sha256:" + hashlib.sha256(data).hexdigest():
            raise ValueError(f"GitHub asset digest mismatch: {name}")
        return data

    manifest = json.loads(download("manifest.json", 1024 * 1024))
    hashes = manifest_hashes(manifest, tag)
    sums = download("SHA256SUMS.txt", 1024 * 1024).decode("utf-8")
    expected_sums = {f"{digest}  loboot-{tag}-{target}.tar.gz" for target, digest in hashes.items()}
    lines = sums.splitlines()
    if len(lines) != len(TARGETS) or set(lines) != expected_sums:
        raise ValueError("SHA256SUMS.txt does not match the four manifest archives")
    for target, expected in hashes.items():
        name = f"loboot-{tag}-{target}.tar.gz"
        actual = hashlib.sha256(download(name, MAX_ARCHIVE)).hexdigest()
        if actual != expected:
            raise ValueError(f"Archive SHA-256 mismatch: {name}")
    candidate = render_update(formula, tag, hashes)
    published_formula = download("loboot.rb", 1024 * 1024).decode("utf-8")
    if candidate != normalize_formula(published_formula):
        raise ValueError("Release changes reviewed formula behavior; open a manual PR")
    return tag, candidate


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--formula", type=Path, default=Path("Formula/loboot.rb"))
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--github-output", type=Path)
    args = parser.parse_args()
    formula_bytes = args.formula.read_bytes()
    formula = normalize_formula(formula_bytes.decode("utf-8"))
    previous = current_version(formula)
    release = json.loads(fetch(LATEST_API, 1024 * 1024))
    tag, _ = release_assets(release)
    if version_tuple(tag[1:]) <= version_tuple(previous):
        outputs = {"changed": "false"}
        print(f"Loboot {previous} is current; no update staged.")
    else:
        tag, candidate = verify_release(release, formula)
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(candidate, encoding="utf-8")
        outputs = {
            "changed": "true",
            "tag": tag,
            "previous_sha256": hashlib.sha256(formula_bytes).hexdigest(),
            "candidate_sha256": hashlib.sha256(candidate.encode("utf-8")).hexdigest(),
        }
        print(f"Verified all four {tag} archives; candidate formula staged for Homebrew tests.")
    if args.github_output:
        with args.github_output.open("a", encoding="utf-8") as stream:
            for key, value in outputs.items():
                stream.write(f"{key}={value}\n")


if __name__ == "__main__":
    try:
        main()
    except (ValueError, KeyError, TypeError, OSError) as error:
        print(f"Loboot update refused: {error}", file=sys.stderr)
        sys.exit(1)
