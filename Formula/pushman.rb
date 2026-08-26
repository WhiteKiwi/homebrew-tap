class Pushman < Formula
  desc "Send push notifications to your iPhone from the command-line"
  homepage "https://github.com/WhiteKiwi/pushman-cli"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/pushman-cli/releases/download/v0.1.0/pushman_0.1.0_macOS_arm64.tar.gz"
      sha256 "5b6c808f123fe3f3398db47a17ced77b8428349d67c8e2648c6fb84f84bcfc7b"
    else
      url "https://github.com/WhiteKiwi/pushman-cli/releases/download/v0.1.0/pushman_0.1.0_macOS_x86_64.tar.gz"
      sha256 "3cdde5f5a2961a6adaf48278b7fe5aa6c0131b727d8641dd7764bbd05efce30c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/pushman-cli/releases/download/v0.1.0/pushman_0.1.0_linux_arm64.tar.gz"
      sha256 "f4333b28c0822fcb4f95912f5e55ef98704866455d93a2338aac34681b6578df"
    else
      url "https://github.com/WhiteKiwi/pushman-cli/releases/download/v0.1.0/pushman_0.1.0_linux_x86_64.tar.gz"
      sha256 "f49b4ae665369e868f9479b96f594add025985d25441133532b0356a796b10fd"
    end
  end

  def install
    bin.install "pushman"
  end

  test do
    assert_match "pushman #{version}", shell_output("#{bin}/pushman version")
  end
end
