class Locron < Formula
  desc "Local-first job scheduler for macOS and Linux"
  homepage "https://github.com/WhiteKiwi/locron"
  version "0.4.1"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "ba8446b09a68903d5b408e6dfe8e85559fc19f921660878a55f8c18057350fe4"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "404f0a6b678160048b79992e4f34c23fec827bcae8c2d0f01f94b2db558aa956"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "82dd2487f75cf8afa39eb5400f36524a9353200921c95d53b721a03fc36f0e9e"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "853354ba84312c25209937e3be75d4f826225d59fb603f0c56d7d4556c9b8253"
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
