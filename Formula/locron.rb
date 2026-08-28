class Locron < Formula
  desc "Local-first job scheduler for macOS and Linux"
  homepage "https://github.com/WhiteKiwi/locron"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.3/locron-v0.9.3-aarch64-apple-darwin.tar.gz"
      sha256 "9d48789c0c6dfe36535526b4f91593c98bf0bef4b70efd1e1b7c498d89349c08"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.3/locron-v0.9.3-x86_64-apple-darwin.tar.gz"
      sha256 "3c51055e2127a8fcdb12014a8e668a59e3c8053daec70c15daf96001a78bdb5f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.3/locron-v0.9.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4d47f5af5ae1870f7c96a1a088331264c296f47dc477ab2fa7a7cbe4cefadbb3"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.3/locron-v0.9.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "98436a587aba8f6480e06e0df209c278685987e8a9e0776e6cbf9a5bb084e746"
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
