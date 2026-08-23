class Locron < Formula
  desc "Local-first job scheduler for macOS and Linux"
  homepage "https://github.com/WhiteKiwi/locron"
  version "0.4.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "c0c0c292853e282c77c26f066537f51a7dcb9d5c2e170c0fb42bdfcc3e0f2023"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "d3543fe8b46269c9ea0a3674e73970af8fc78d3bba3c4713836a8e2e05c2df89"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "85a9f86cbc3eb454c9cf8029b44676debcd1f69520f8dd51a6d9beaf770b3abe"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a75407e46138442e11d855c83b703509af433470ec930772991d2986aeb03f45"
    end
  end

  def install
    bin.install "locron"
    # Mark this install as package-manager-managed so that
    # `locron self-update` refuses to replace the binary and
    # directs users to `brew upgrade locron`.
    lib.mkpath
    FileUtils.touch lib/".disable-self-update"
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
