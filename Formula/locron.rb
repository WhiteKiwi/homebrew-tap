class Locron < Formula
  desc "Local-first job scheduler for macOS and Linux"
  homepage "https://github.com/WhiteKiwi/locron"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.1/locron-v0.9.1-aarch64-apple-darwin.tar.gz"
      sha256 "cafc6bc17807f9d4131a09942ef2017c64891c14c3866f26464128715737c5b0"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.1/locron-v0.9.1-x86_64-apple-darwin.tar.gz"
      sha256 "4368067f72569a50ad75f1349dee7ef525c4aacff9fd06a6dcdd0bb0435f8bd2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.1/locron-v0.9.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "49e4fc47cbda3cb8acf42abe5e753e74cba2b4f0126e1412e3b0a2f779112900"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.1/locron-v0.9.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fc10913078855979227dd47840421e28af3949c71a6bf2b1f0fc2c1b74ec733c"
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
