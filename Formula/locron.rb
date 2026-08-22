class Locron < Formula
  desc "Local-first job scheduler for macOS and Linux"
  homepage "https://github.com/WhiteKiwi/locron"
  version "0.1.1"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "384589f91d75b2745c466745194c19eb8c49c90abaeb5dcd81964b0e36c1dfc3"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "7fa513adec9dad4a3b372ceba5fa5ba969e26fd809e27b518bb443b651584f87"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "45bc5faaea62a8b0244c688f9d9557f2073cbeb0d5b3cc706a5bb0810dea7e0f"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "27db9bd37c82049977716d7746171240058320efd841d85267eadbcc1ca1a6fe"
    end
  end

  def install
    bin.install "locron"
  end

  test do
    assert_match "locron", shell_output("#{bin}/locron --version")
  end
end
