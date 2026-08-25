class Locron < Formula
  desc "Local-first job scheduler for macOS and Linux"
  homepage "https://github.com/WhiteKiwi/locron"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.8.0/locron-v0.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "733b1b6334bf1295328f3ff6a1f56255f7eb8995e605ed67da4dec59589bc83a"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.8.0/locron-v0.8.0-x86_64-apple-darwin.tar.gz"
      sha256 "f773abd96e339378bfc1805e9a202077df71347f12fda15eb4a3e4cc175c2d8e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.8.0/locron-v0.8.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cf3ad96325a43cbe80ceede3f7037a7f81d7bae018fb260ee1998679bfa34da8"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.8.0/locron-v0.8.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f1aaaadd1a27f2382632c3c8b36f07b3ed3b17b40c607baa2cc238a5531fdca1"
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
