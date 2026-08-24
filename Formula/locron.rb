class Locron < Formula
  desc "Local-first job scheduler for macOS and Linux"
  homepage "https://github.com/WhiteKiwi/locron"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.7.0/locron-v0.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "2317a72a9a13e4ab1682fce27309888cb221c61f87e8b576b0d0e6d776f5da99"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.7.0/locron-v0.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "4d6b60237719596497ecd23927d5f65f54e209fbce9af542692e7c7ca4652c78"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.7.0/locron-v0.7.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f6b2b92ead095921b695011cd9318d11988faf4bdb9909928e45e7b2747e8ad3"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.7.0/locron-v0.7.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d45ddd2b9d61df29d76e178e0d5522ab1fe307d4c5c34239be716f42fc868022"
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
