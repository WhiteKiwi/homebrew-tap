class Pushman < Formula
  desc "Send push notifications to your iPhone from the command-line"
  homepage "https://github.com/pushmanhq/pushman"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.4.1/pushman_0.4.1_macOS_arm64.tar.gz"
      sha256 "b32219cf568ebfe3b90868bfdfe12ea393fe6c97ebcf2c6e8575acaa8d1e381b"
    else
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.4.1/pushman_0.4.1_macOS_x86_64.tar.gz"
      sha256 "53c771d9519d9366832f33847e2c998deb42cbfc8b8d73df2afc0799e4212423"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.4.1/pushman_0.4.1_linux_arm64.tar.gz"
      sha256 "10e0ff9092f75f856bc56e152b41159be4251f72f8d76bece3b33fbcbb9d3712"
    else
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.4.1/pushman_0.4.1_linux_x86_64.tar.gz"
      sha256 "4c37a6a8537b7066da5e592dac1f4fd2ed197a135204b0c9a9f94886b274092b"
    end
  end

  def install
    bin.install "pushman"
  end

  test do
    assert_match "pushman #{version}", shell_output("#{bin}/pushman version")
  end
end
