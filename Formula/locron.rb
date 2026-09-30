class Locron < Formula
  desc "Local-first job scheduler for macOS and Linux"
  homepage "https://github.com/WhiteKiwi/locron"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.6/locron-v0.9.6-aarch64-apple-darwin.tar.gz"
      sha256 "c9d368ade92349c27563709d4b574893ef2c37816c28b6f7f023f2462ada9181"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.6/locron-v0.9.6-x86_64-apple-darwin.tar.gz"
      sha256 "40ddf6f49e49fd70a7fe88d8aa29d66f9697afdf2e3ae206babb929db384ce32"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.6/locron-v0.9.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fdea7391f4cba9b68a4762ad1bd3b178abe3b60cdbaf68b487a69d74fe60eb11"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.6/locron-v0.9.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "37d578feb15138511b78d6c71a075551a12354eb0bf98669ee1b4706e9c94711"
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
