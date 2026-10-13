import copy
import hashlib
import importlib.util
import json
from pathlib import Path
import unittest
import tempfile
from unittest.mock import patch

SPEC = importlib.util.spec_from_file_location("updater", Path(__file__).parents[1] / "scripts/update_loboot.py")
updater = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(updater)


class UpdateLobootTests(unittest.TestCase):
    def setUp(self):
        self.tag = "v1.2.3"
        self.formula = 'class Loboot < Formula\n  version "1.2.2"\n' + "".join(
            f'  url "{updater.URL_ROOT}/v1.2.2/loboot-v1.2.2-{target}.tar.gz"\n'
            f'  sha256 "{"0" * 64}"\n' for target in updater.TARGETS
        ) + "end\n"
        self.data = {}
        artifacts = []
        hashes = {}
        for target in updater.TARGETS:
            name = f"loboot-{self.tag}-{target}.tar.gz"
            self.data[name] = ("fixture " + target).encode()
            digest = hashlib.sha256(self.data[name]).hexdigest()
            hashes[target] = digest
            artifacts.append({"schema_version": updater.SCHEMA, "version": "1.2.3", "target": target, "archive": name, "sha256": digest})
        self.manifest = {"schema_version": updater.SCHEMA, "version": "1.2.3", "artifacts": artifacts}
        self.data["manifest.json"] = json.dumps(self.manifest).encode()
        self.data["SHA256SUMS.txt"] = "".join(f"{hashes[target]}  loboot-{self.tag}-{target}.tar.gz\n" for target in updater.TARGETS).encode()
        self.expected = updater.render_update(self.formula, self.tag, hashes)
        self.data["loboot.rb"] = self.expected.encode()
        self.release = {"tag_name": self.tag, "draft": False, "prerelease": False, "assets": [
            {"name": name, "state": "uploaded", "size": len(data), "digest": "sha256:" + hashlib.sha256(data).hexdigest(),
             "browser_download_url": f"{updater.URL_ROOT}/{self.tag}/{name}"}
            for name, data in self.data.items()
        ]}

    def download(self, url, limit):
        data = self.data[url.rsplit("/", 1)[1]]
        self.assertLessEqual(len(data), limit)
        return data

    def mutate_asset(self, name, data):
        self.data[name] = data
        asset = next(a for a in self.release["assets"] if a["name"] == name)
        asset["size"] = len(data)
        asset["digest"] = "sha256:" + hashlib.sha256(data).hexdigest()

    def test_valid_release(self):
        self.assertEqual(updater.verify_release(self.release, self.formula, self.download), (self.tag, self.expected))

    def test_stable_version_only(self):
        for bad in ["1.2.3-beta", "01.2.3", "1.2", "1.2.3\n", "v1.2.3", "1.2.3;echo bad", None]:
            with self.subTest(bad=bad), self.assertRaises(ValueError):
                updater.version_tuple(bad)

    def test_missing_asset(self):
        self.release["assets"].pop()
        with self.assertRaisesRegex(ValueError, "Missing"):
            updater.verify_release(self.release, self.formula, self.download)

    def test_duplicate_asset(self):
        self.release["assets"].append(self.release["assets"][0])
        with self.assertRaisesRegex(ValueError, "Duplicate"):
            updater.release_assets(self.release)

    def test_unexpected_download_url(self):
        self.release["assets"][0]["browser_download_url"] = "https://example.com/asset"
        with self.assertRaisesRegex(ValueError, "Unexpected"):
            updater.release_assets(self.release)

    def test_unpublished_release(self):
        for field in ("draft", "prerelease"):
            release = copy.deepcopy(self.release)
            release[field] = True
            with self.assertRaisesRegex(ValueError, "published stable"):
                updater.release_assets(release)

    def test_asset_size_limit(self):
        self.release["assets"][0]["size"] = updater.MAX_ARCHIVE + 1
        with self.assertRaisesRegex(ValueError, "size"):
            updater.release_assets(self.release)

    def test_asset_size_mismatch(self):
        self.release["assets"][0]["size"] += 1
        with self.assertRaisesRegex(ValueError, "size mismatch"):
            updater.verify_release(self.release, self.formula, self.download)

    def test_missing_github_digest(self):
        self.release["assets"][0].pop("digest")
        with self.assertRaisesRegex(ValueError, "GitHub asset digest"):
            updater.release_assets(self.release)

    def test_github_digest_mismatch(self):
        self.release["assets"][0]["digest"] = "sha256:" + "0" * 64
        with self.assertRaisesRegex(ValueError, "GitHub asset digest"):
            updater.verify_release(self.release, self.formula, self.download)

    def test_archive_digest_mismatch(self):
        name = self.release["assets"][0]["name"]
        self.mutate_asset(name, b"tampered")
        with self.assertRaisesRegex(ValueError, "Archive SHA-256"):
            updater.verify_release(self.release, self.formula, self.download)

    def test_manifest_target_inventory(self):
        for change in ("missing", "duplicate", "unsupported"):
            manifest = copy.deepcopy(self.manifest)
            if change == "missing":
                manifest["artifacts"].pop()
            elif change == "duplicate":
                manifest["artifacts"].append(manifest["artifacts"][0])
            else:
                manifest["artifacts"][0]["target"] = "i686-linux"
            with self.subTest(change=change), self.assertRaises(ValueError):
                updater.manifest_hashes(manifest, self.tag)

    def test_manifest_version_and_schema(self):
        for field in ("version", "schema_version"):
            manifest = copy.deepcopy(self.manifest)
            manifest[field] = "invalid"
            with self.subTest(field=field), self.assertRaises(ValueError):
                updater.manifest_hashes(manifest, self.tag)

    def test_checksums_match_exactly(self):
        self.mutate_asset("SHA256SUMS.txt", self.data["SHA256SUMS.txt"] + b"unverified archive\n")
        with self.assertRaisesRegex(ValueError, "SHA256SUMS"):
            updater.verify_release(self.release, self.formula, self.download)

    def test_formula_behavior_changes_refused(self):
        self.mutate_asset("loboot.rb", (self.expected + 'system "unexpected"\n').encode())
        with self.assertRaisesRegex(ValueError, "formula behavior"):
            updater.verify_release(self.release, self.formula, self.download)

    def test_formula_mixed_versions_refused(self):
        formula = self.formula.replace("/v1.2.2/", "/v1.2.1/", 1)
        with self.assertRaises(ValueError):
            updater.current_version(formula)

    def test_explicit_formula_version_mismatch(self):
        formula = self.formula.replace('version "1.2.2"', 'version "1.2.1"')
        with self.assertRaisesRegex(ValueError, "Explicit formula version"):
            updater.current_version(formula)

    def test_main_stages_only_a_verified_new_release(self):
        with tempfile.TemporaryDirectory() as root:
            formula, output, metadata = (Path(root) / name for name in ("formula.rb", "candidate.rb", "outputs"))
            formula.write_text(self.formula)
            arguments = ["update_loboot.py", "--formula", str(formula), "--output", str(output), "--github-output", str(metadata)]
            with patch("sys.argv", arguments), patch.object(updater, "fetch", return_value=json.dumps(self.release).encode()), patch.object(updater, "verify_release", return_value=(self.tag, self.expected)) as verify:
                updater.main()
            verify.assert_called_once()
            self.assertEqual(output.read_text(), self.expected)
            self.assertIn("changed=true\n", metadata.read_text())
            self.assertIn("tag=v1.2.3\n", metadata.read_text())
            self.assertIn("candidate_sha256=" + hashlib.sha256(self.expected.encode()).hexdigest() + "\n", metadata.read_text())
            self.assertEqual(formula.read_text(), self.formula)

    def test_main_never_downgrades(self):
        for current in ("1.2.3", "2.0.0"):
            with self.subTest(current=current), tempfile.TemporaryDirectory() as root:
                formula, output, metadata = (Path(root) / name for name in ("formula.rb", "candidate.rb", "outputs"))
                formula.write_text(self.formula.replace("1.2.2", current))
                arguments = ["update_loboot.py", "--formula", str(formula), "--output", str(output), "--github-output", str(metadata)]
                with patch("sys.argv", arguments), patch.object(updater, "fetch", return_value=json.dumps(self.release).encode()), patch.object(updater, "verify_release") as verify:
                    updater.main()
                verify.assert_not_called()
                self.assertFalse(output.exists())
                self.assertEqual(metadata.read_text(), "changed=false\n")

    def test_formula_duplicate_target_refused(self):
        formula = self.formula.replace(updater.TARGETS[0], updater.TARGETS[1])
        with self.assertRaisesRegex(ValueError, "one reviewed"):
            updater.render_update(formula, self.tag, updater.manifest_hashes(self.manifest, self.tag))


if __name__ == "__main__":
    unittest.main()
