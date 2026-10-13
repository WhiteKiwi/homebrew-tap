<h1 align="center">whitekiwi/tap</h1>

<p align="center">
  <strong>Homebrew packages for WhiteKiwi command-line tools.</strong>
</p>

<p align="center">
  <a href="https://github.com/WhiteKiwi/homebrew-tap/actions/workflows/tests.yml"><img src="https://github.com/WhiteKiwi/homebrew-tap/actions/workflows/tests.yml/badge.svg" alt="brew test-bot"></a>
  <a href="#license"><img src="https://img.shields.io/badge/license-MIT%20%2F%20Apache--2.0-blue.svg" alt="License"></a>
</p>

---

## Install

Install a fully qualified Formula directly. Homebrew adds the tap automatically and trusts only the selected Formula:

```sh
brew install whitekiwi/tap/pushman
brew install whitekiwi/tap/locron
brew install whitekiwi/tap/loboot
```

After installation, upgrades and removal work by short name: `brew upgrade pushman`, `brew uninstall pushman`, `brew upgrade locron`, `brew uninstall locron`, `brew upgrade loboot`, and `brew uninstall loboot`. Trust the whole tap only if you explicitly accept every current and future package in it.

## Formulae

| Formula | Description | Upstream |
| --- | --- | --- |
| [pushman](Formula/pushman.rb) | Send push notifications to your iPhone from the command line | [pushmanhq/pushman-cli](https://github.com/pushmanhq/pushman-cli) |
| [locron](Formula/locron.rb) | Local-first job scheduler for macOS and Linux | [WhiteKiwi/locron](https://github.com/WhiteKiwi/locron) |
| [loboot](Formula/loboot.rb) | Explicit native user-service management without a daemon | [WhiteKiwi/loboot](https://github.com/WhiteKiwi/loboot) |

## Maintenance

This tap is kept current automatically and needs no manual version bumps:

- **Release pipelines** — every Pushman CLI and locron release pushes its reviewed Formula with the new version and checksums for all four platform builds (macOS and Linux, x86_64 and arm64).
- **Autobump** — a [daily workflow](.github/workflows/autobump.yml) runs `brew bump` with `livecheck` against GitHub Releases and opens a pull request if a version falls behind.
- **Loboot updates** — the same daily workflow checks the latest stable Loboot release at 03:15 UTC (GitHub may delay scheduled runs). It verifies all four archives against the release manifest, checksum file, and GitHub asset digests, then installs, tests, audits, and style-checks the candidate on macOS and Linux before committing it. Changes to formula behavior require a normal PR. Use **Run workflow** with the `main` branch on the [brew bump Actions page](https://github.com/WhiteKiwi/homebrew-tap/actions/workflows/autobump.yml) to check sooner. No cross-repository token is needed.
- **Test bot** — every push and pull request runs `brew test-bot` on macOS and Linux.

## Testing

Contributions are welcome — open a pull request and the [test bot](.github/workflows/tests.yml) runs the full `brew test-bot` lifecycle (install, test, audit) on macOS and Linux. To check locally before pushing:

```sh
brew install whitekiwi/tap/locron
brew install whitekiwi/tap/loboot
brew install whitekiwi/tap/pushman
brew test whitekiwi/tap/locron
brew test whitekiwi/tap/loboot
brew test whitekiwi/tap/pushman
brew audit --tap=whitekiwi/tap
python3 -m unittest discover -s tests -v
```

Loboot's formula tests use an isolated offline root. Installation and tests do not
start services or touch the current user's service definitions. Loboot itself has
no daemon, so it has no `brew services` entry.

The Loboot updater validates before writing because commits made with the
workflow's built-in `GITHUB_TOKEN` do not trigger another push workflow. If an
update fails, the existing formula stays in place. For a manual update, download
the seven release assets, including `loboot.rb`, from the [published release](https://github.com/WhiteKiwi/loboot/releases),
run `shasum -a 256 --check SHA256SUMS.txt` beside the four archives, review the formula changes, open a PR, and let the test bot finish before merging.

## Documentation

- [`brew tap`](https://docs.brew.sh/Taps) — how third-party taps work.
- [Formula Cookbook](https://docs.brew.sh/Formula-Cookbook) — Homebrew's reference for writing and testing formulae.
- [Pushman CLI documentation](https://github.com/pushmanhq/pushman-cli#readme) — pairing, push commands, automation, and security.
- [Loboot documentation](https://github.com/WhiteKiwi/loboot#readme) — installation, offline review, and native user-service commands.
- [locron documentation](https://github.com/WhiteKiwi/locron#-documentation) — operator guide, CLI reference, and release policy.

## License

Formula metadata in this repository is dual-licensed under either of:

- MIT License ([`LICENSE`](LICENSE))
- Apache License, Version 2.0 ([https://www.apache.org/licenses/LICENSE-2.0](https://www.apache.org/licenses/LICENSE-2.0))

at your option. Each upstream project is distributed under the license declared by its own repository.
