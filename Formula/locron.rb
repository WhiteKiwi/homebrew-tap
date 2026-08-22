class Locron < Formula
  desc "Local-first job scheduler for macOS and Linux"
  homepage "https://github.com/WhiteKiwi/locron"
  version "0.1.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "ddc3c79969161ee41ceec89a40da522e92aa6b96f3954373699ab1b3c65acfd4"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "308b1f8de316138bcf0a575d021ce77a2a81bd584c9d6aef9f7a4d96af043d51"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5d6607feb06b6c7dad364cc5208820f744c2206c7b7d70ce1499ef7d0454fb30"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d323f9fa24450fe555a1f6021f973671331d3c460a8dbdd397cc386dd77c6019"
    end
  end

  def install
    bin.install "locron"
  end

  test do
    assert_match "locron", shell_output("#{bin}/locron --version")
  end
end
