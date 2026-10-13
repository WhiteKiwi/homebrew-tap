class Pushman < Formula
  desc "Send push notifications to your iPhone from the command-line"
  homepage "https://github.com/pushmanhq/pushman"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.5.0/pushman_0.5.0_macOS_arm64.tar.gz"
      sha256 "ceb6b6e54b47d5409c8d67d32376b742cc61a027209b41a1c3bc1447806d4116"
    else
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.5.0/pushman_0.5.0_macOS_x86_64.tar.gz"
      sha256 "2cc29cf0044b30f6ef32165d7befb72efedd4f4e82c9874091eb74cece94be95"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.5.0/pushman_0.5.0_linux_arm64.tar.gz"
      sha256 "f8b9d3396e722cd09aee70f6a4581efee6df90d45c9a09d765fcbedea4fd8589"
    else
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.5.0/pushman_0.5.0_linux_x86_64.tar.gz"
      sha256 "63651dc279f237af9b0c563c4b5c24c582b1d31390cb898a1ee4bda22b9698d9"
    end
  end

  def install
    bin.install "pushman"
  end

  test do
    assert_match "pushman #{version}", shell_output("#{bin}/pushman version")
  end
end
