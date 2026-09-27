class Pushman < Formula
  desc "Send push notifications to your iPhone from the command-line"
  homepage "https://github.com/pushmanhq/pushman"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.3.0/pushman_0.3.0_macOS_arm64.tar.gz"
      sha256 "0655b3acbe1ace7c7ba3d44b7945fa9611f79776d7eb27efa17628b3cb9d4c18"
    else
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.3.0/pushman_0.3.0_macOS_x86_64.tar.gz"
      sha256 "24f61d06abf517b75a34a30930946ac10ac614da3ee09354f52adff8ed011e2a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.3.0/pushman_0.3.0_linux_arm64.tar.gz"
      sha256 "bfac36a1bad87f3da174c3a09cacfb1b20c65419cf90024f5d34d5a5cecc822d"
    else
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.3.0/pushman_0.3.0_linux_x86_64.tar.gz"
      sha256 "dacb56708f2ec4ed71b21510530bbf5703171b8437649ae29fd9553e83d66e61"
    end
  end

  def install
    bin.install "pushman"
  end

  test do
    assert_match "pushman #{version}", shell_output("#{bin}/pushman version")
  end
end
