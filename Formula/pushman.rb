class Pushman < Formula
  desc "Send push notifications to your iPhone from the command-line"
  homepage "https://github.com/WhiteKiwi/pushman-cli"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/pushman-cli/releases/download/v0.1.0-beta.3/pushman_0.1.0-beta.3_macOS_arm64.tar.gz"
      sha256 "2d0cc755b4dca8c2a6f101c40f5c23da98d64adbd18b4c157caa8b33ea1713f6"
    else
      url "https://github.com/WhiteKiwi/pushman-cli/releases/download/v0.1.0-beta.3/pushman_0.1.0-beta.3_macOS_x86_64.tar.gz"
      sha256 "80f8f758a5130aaa4bffbb609b028ef407f35fa034461698509ea66985498200"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/pushman-cli/releases/download/v0.1.0-beta.3/pushman_0.1.0-beta.3_linux_arm64.tar.gz"
      sha256 "21b93372a6a06a6d8b7cc5fcfe16302f1cc0bc26a95c1b6a5cdee6966d1face7"
    else
      url "https://github.com/WhiteKiwi/pushman-cli/releases/download/v0.1.0-beta.3/pushman_0.1.0-beta.3_linux_x86_64.tar.gz"
      sha256 "04639c6d04f1adbc66494182939cd590def4e1acb92fc0735e13529e116e3436"
    end
  end

  def install
    bin.install "pushman"
  end

  test do
    assert_match "pushman #{version}", shell_output("#{bin}/pushman version")
  end
end
