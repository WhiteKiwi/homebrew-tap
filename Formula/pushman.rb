class Pushman < Formula
  desc "Send push notifications to your iPhone from the command-line"
  homepage "https://github.com/pushmanhq/pushman-cli"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.1.1/pushman_0.1.1_macOS_arm64.tar.gz"
      sha256 "78cb661e3f5d1d847ea63bc6279dcb1207a121cd75991441e89261edbcac36a2"
    else
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.1.1/pushman_0.1.1_macOS_x86_64.tar.gz"
      sha256 "6a8927a98c5b783814ae87f0457620cd0da71b014ca2057269ba16db4cc673ea"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.1.1/pushman_0.1.1_linux_arm64.tar.gz"
      sha256 "16333977d6bfa90e718071d3f65642791820790c3ba283569caff9e0c0db546d"
    else
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.1.1/pushman_0.1.1_linux_x86_64.tar.gz"
      sha256 "4afa3fa2f231e26fe09a9c37fcef173a850ed75db2c4ef9053f9a2b83d5cf2fe"
    end
  end

  def install
    bin.install "pushman"
  end

  test do
    assert_match "pushman #{version}", shell_output("#{bin}/pushman version")
  end
end
