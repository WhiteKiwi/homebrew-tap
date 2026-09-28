class Locron < Formula
  desc "Local-first job scheduler for macOS and Linux"
  homepage "https://github.com/WhiteKiwi/locron"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.4/locron-v0.9.4-aarch64-apple-darwin.tar.gz"
      sha256 "91e3927e3b140714277c7ea9a4925b59bef40954094f7ce48f19c6e47857091f"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.4/locron-v0.9.4-x86_64-apple-darwin.tar.gz"
      sha256 "0081a0d0bafdb7a70ecf1a256f9298abaaf4b5c064d09d9340e6eedef06dae00"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.4/locron-v0.9.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4ef05f398d4298df422cb11dfebb4efe5facab53e280afba1798716f2ac83c98"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.4/locron-v0.9.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1c2a6d0cba15c7121738dbb467073628e39197941ae278e3347cc463307bb050"
    end
  end

  def install
    bin.install "locron"
    # Mark this install as package-manager-managed so that
    # `locron self-update` refuses to replace the binary and
    # directs users to `brew upgrade locron`.
    lib.mkpath
    touch lib/".disable-self-update"
  end

  service do
    run [opt_bin/"locron", "daemon", "run"]
    keep_alive true
    run_at_load false
  end

  def caveats
    <<~EOS
      Start the locron daemon with:
        brew services start locron
      Installation never starts it automatically, and `brew upgrade`
      leaves a running service on the old version; run
      `brew services restart locron` after an upgrade.
    EOS
  end

  test do
    assert_match "locron", shell_output("#{bin}/locron --version")
  end
end
