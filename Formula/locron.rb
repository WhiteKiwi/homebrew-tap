class Locron < Formula
  desc "Local-first job scheduler for macOS and Linux"
  homepage "https://github.com/WhiteKiwi/locron"
  version "0.3.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "b721587c96221a77ccc2835ad9cb20d4bbda9deb2e620f24189d0df98576010e"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "208c03f95e5983d1494e4f3410d05d3046aeb5af8394c3f0b0d6daec8ed5b3d8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "aaadf7585e2c32def7687cd74ce4f8a15812b3606c5d5b039c6b8d495443af5f"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6895392084d55a9de6fe937055b397dee7f8bedd65a300fdd2f676fe018acaaa"
    end
  end

  def install
    bin.install "locron"
    # Mark this install as package-manager-managed so that
    #  refuses to replace the binary and
    # directs users to .
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
      Installation never starts it automatically, and 
      leaves a running service on the old version; run
       after an upgrade.
    EOS
  end

  test do
    assert_match "locron", shell_output("#{bin}/locron --version")
  end
end
