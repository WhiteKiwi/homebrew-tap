class Pushman < Formula
  desc "Send push notifications to your iPhone from the command-line"
  homepage "https://github.com/pushmanhq/pushman"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.4.2/pushman_0.4.2_macOS_arm64.tar.gz"
      sha256 "871f7bdc835e1cf066a8cc14eb581f10e3393c067da23446700a24357a2d1bf6"
    else
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.4.2/pushman_0.4.2_macOS_x86_64.tar.gz"
      sha256 "46a819e349d5c9ba7641d6d47ce36a9ce4e9072c74185694fe70879f9197d4ea"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.4.2/pushman_0.4.2_linux_arm64.tar.gz"
      sha256 "00d268989d0df6b0a9e64756fe42e72e7826fbe3b991bf23799507af352ac070"
    else
      url "https://github.com/pushmanhq/pushman-cli/releases/download/v0.4.2/pushman_0.4.2_linux_x86_64.tar.gz"
      sha256 "ae8627179c68c7b5fe1b53b6bb3dacfc877b7c57cf2ccaa6b8fe2d9417d79e46"
    end
  end

  def install
    bin.install "pushman"
  end

  test do
    assert_match "pushman #{version}", shell_output("#{bin}/pushman version")
  end
end
