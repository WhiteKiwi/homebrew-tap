class Pushman < Formula
  desc "Send push notifications to your iPhone from the command-line"
  homepage "https://github.com/WhiteKiwi/pushman-cli"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/pushman-cli/releases/download/v0.1.0-beta.2/pushman_0.1.0-beta.2_macOS_arm64.tar.gz"
      sha256 "5abd3955a819f014ba5f870cda5a7d7129442345c30c6d37893f5761506762a5"
    else
      url "https://github.com/WhiteKiwi/pushman-cli/releases/download/v0.1.0-beta.2/pushman_0.1.0-beta.2_macOS_x86_64.tar.gz"
      sha256 "ca0bd4adae54f229c21099a92f48743fe548ac22d36d4698b28e78f9e71229bb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/pushman-cli/releases/download/v0.1.0-beta.2/pushman_0.1.0-beta.2_linux_arm64.tar.gz"
      sha256 "e49249fc23686c8bead86b116be7f0f8068e1ff1f75dfe525a7ac832aa07635c"
    else
      url "https://github.com/WhiteKiwi/pushman-cli/releases/download/v0.1.0-beta.2/pushman_0.1.0-beta.2_linux_x86_64.tar.gz"
      sha256 "c7c7a1061d5995be48b596a8d4ce4b0b96b7bcb7c92bb30800091fd98a29f5d2"
    end
  end

  def install
    bin.install "pushman"
  end

  test do
    assert_match "pushman #{version}", shell_output("#{bin}/pushman version")
  end
end
