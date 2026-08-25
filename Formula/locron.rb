class Locron < Formula
  desc "Local-first job scheduler for macOS and Linux"
  homepage "https://github.com/WhiteKiwi/locron"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.2/locron-v0.9.2-aarch64-apple-darwin.tar.gz"
      sha256 "a88855f1afbed0b2a5fe2267ffebe4dec97fda3e2f24a987e8f275e42df51679"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.2/locron-v0.9.2-x86_64-apple-darwin.tar.gz"
      sha256 "d5ece2b955133dd6f6cca25a9aaf6b5e6101dff28422bfa47ac11c389483e4e9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.2/locron-v0.9.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1f40d26bf184a0eba35e294d0202ac6967856f3906f9000a1b80d4844103d00a"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.2/locron-v0.9.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "41441bc8e6bfa2dafac2a780de8a71919e3481cdbae1a749ad4dd16382bf1eaa"
    end
  end

  def install
    bin.install "locron"
    # Mark this install as package-manager-managed so that
    # `locron self-update` refuses to replace the binary and
    # directs users to `brew upgrade locron`.
    lib.mkpath
    touch lib/".disable-self-update"
  end

  service do
    run [opt_bin/"locron", "daemon", "run"]
    keep_alive true
    run_at_load false
  end

  def caveats
    <<~EOS
      Start the locron daemon with:
        brew services start locron
      Installation never starts it automatically, and `brew upgrade`
      leaves a running service on the old version; run
      `brew services restart locron` after an upgrade.
    EOS
  end

  test do
    assert_match "locron", shell_output("#{bin}/locron --version")
  end
end
