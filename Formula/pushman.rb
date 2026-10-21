class Pushman < Formula
  desc "Send push notifications to your iPhone from the command-line"
  homepage "https://github.com/pushmanhq/pushman"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.5.2/pushman_0.5.2_macOS_arm64.tar.gz"
      sha256 "8781f9defb0a6fd5514b528568fca5cec31244a2ff02ff820998e318bfaf386e"
    else
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.5.2/pushman_0.5.2_macOS_x86_64.tar.gz"
      sha256 "e7edf19a99f764bd690b068cf33d0b05c7a94d2f3c912fdad24db20c8286aa0e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.5.2/pushman_0.5.2_linux_arm64.tar.gz"
      sha256 "53a31bc5c19ffd2e494f273de76d9457e0f02b8a1649dbc0d91ae9e7c169d300"
    else
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.5.2/pushman_0.5.2_linux_x86_64.tar.gz"
      sha256 "9d9e327783056bd58a30c573c7da44b499d74574bb5ce53a34f7347d83d282ed"
    end
  end

  def install
    bin.install "pushman"
  end

  test do
    assert_match "pushman #{version}", shell_output("#{bin}/pushman version")
  end
end
