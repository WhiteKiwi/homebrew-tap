class Pushman < Formula
  desc "Send push notifications to your iPhone from the command-line"
  homepage "https://github.com/WhiteKiwi/pushman-cli"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/pushman-cli/releases/download/v0.1.0-beta.4/pushman_0.1.0-beta.4_macOS_arm64.tar.gz"
      sha256 "f02e2b439bd6aa4f1bcd4835cb4b4ec0e7ae5c3c9a9d6034a0c3fc36e96ba7fa"
    else
      url "https://github.com/WhiteKiwi/pushman-cli/releases/download/v0.1.0-beta.4/pushman_0.1.0-beta.4_macOS_x86_64.tar.gz"
      sha256 "73251b6f952c9aca6fea6dfbcf8779697833797648e1d54284427db5f94e4c40"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/pushman-cli/releases/download/v0.1.0-beta.4/pushman_0.1.0-beta.4_linux_arm64.tar.gz"
      sha256 "ed6e83ef89aa19d97091859fe9c4b6fe7f61e9e592e58030f7b654d5a0c5fa59"
    else
      url "https://github.com/WhiteKiwi/pushman-cli/releases/download/v0.1.0-beta.4/pushman_0.1.0-beta.4_linux_x86_64.tar.gz"
      sha256 "0f6ce96813e4ff55b7d65575f7dd2f4f517e831b694ca88780f26576e8761c95"
    end
  end

  def install
    bin.install "pushman"
  end

  test do
    assert_match "pushman #{version}", shell_output("#{bin}/pushman version")
  end
end
