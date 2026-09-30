class Locron < Formula
  desc "Local-first job scheduler for macOS and Linux"
  homepage "https://github.com/WhiteKiwi/locron"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.5/locron-v0.9.5-aarch64-apple-darwin.tar.gz"
      sha256 "9dd045b2ced1e5d72ac6e9f5d33901fbaf4fca34aca01b88ad8aeded60533fb8"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.5/locron-v0.9.5-x86_64-apple-darwin.tar.gz"
      sha256 "5f7f79c587dd860931fa1bdd5d0e849396df2614071db077e0e4f384eaefc56d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.5/locron-v0.9.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d4871ff5979f6129da8edf1f67399d2b7103ade77e4ece808152440887bc2ec4"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.5/locron-v0.9.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "31cef4433d750d5f711cc6315fea9382a9a97f8d0f374d44463ac473008af82a"
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
