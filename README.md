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
```

After installation, upgrades and removal work by short name: `brew upgrade pushman`, `brew uninstall pushman`, `brew upgrade locron`, and `brew uninstall locron`. Trust the whole tap only if you explicitly accept every current and future package in it.

## Formulae

| Formula | Description | Upstream |
| --- | --- | --- |
| [pushman](Formula/pushman.rb) | Send push notifications to your iPhone from the command line | [pushmanhq/pushman-cli](https://github.com/pushmanhq/pushman-cli) |
| [locron](Formula/locron.rb) | Local-first job scheduler for macOS and Linux | [WhiteKiwi/locron](https://github.com/WhiteKiwi/locron) |

## Maintenance

This tap is kept current automatically and needs no manual version bumps:

- **Release pipelines** — every Pushman CLI and locron release pushes its reviewed Formula with the new version and checksums for all four platform builds (macOS and Linux, x86_64 and arm64).
- **Autobump** — a [daily workflow](.github/workflows/autobump.yml) runs `brew bump` with `livecheck` against GitHub Releases and opens a pull request if a version falls behind.
- **Test bot** — every push and pull request runs `brew test-bot` on macOS and Linux.

## Testing

Contributions are welcome — open a pull request and the [test bot](.github/workflows/tests.yml) runs the full `brew test-bot` lifecycle (install, test, audit) on macOS and Linux. To check locally before pushing:

```sh
brew install whitekiwi/tap/locron
brew install whitekiwi/tap/pushman
brew test whitekiwi/tap/locron
brew test whitekiwi/tap/pushman
brew audit --tap=whitekiwi/tap
```

## Documentation

- [`brew tap`](https://docs.brew.sh/Taps) — how third-party taps work.
- [Formula Cookbook](https://docs.brew.sh/Formula-Cookbook) — Homebrew's reference for writing and testing formulae.
- [Pushman CLI documentation](https://github.com/pushmanhq/pushman-cli#readme) — pairing, push commands, automation, and security.
- [locron documentation](https://github.com/WhiteKiwi/locron#-documentation) — operator guide, CLI reference, and release policy.

## License

Formula metadata in this repository is dual-licensed under either of:

- MIT License ([`LICENSE`](LICENSE))
- Apache License, Version 2.0 ([https://www.apache.org/licenses/LICENSE-2.0](https://www.apache.org/licenses/LICENSE-2.0))

at your option. Each upstream project is distributed under the license declared by its own repository.
