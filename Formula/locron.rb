class Locron < Formula
  desc "Local-first job scheduler for macOS and Linux"
  homepage "https://github.com/WhiteKiwi/locron"
  version "0.2.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "de062edd19f66539dd4d7c2177a3a4ed699517feecbc84afd80f36037df34469"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "d72f1f58fb6eade2825cff3b4a04e4b056692cb49a4acf8ebaadd8f4c2f920b1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1ac015d42a1885aefdfd64e886bf4fc0705d1cdf12c1e1e51a6e19ab0d1b0af5"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v#{version}/locron-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5344e459c8547b9cf0dde29cbfc8f6f9bda3f03e6fc5e28a4e6c123a022660d5"
    end
  end

  def install
    bin.install "locron"
  end

  test do
    assert_match "locron", shell_output("#{bin}/locron --version")
  end
end
