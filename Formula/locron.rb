class Locron < Formula
  desc "Local-first job scheduler for macOS and Linux"
  homepage "https://github.com/WhiteKiwi/locron"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.6.0/locron-v0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "6ef88f8ced1c7aa53b6d25cd78b65505a43e04e92463b7cea570e4ef7f63b512"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.6.0/locron-v0.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "5e5a65ce54f89cb8eeebceaa52eda815394d413065644e24148620a5f07f2700"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.6.0/locron-v0.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2c882053437e09184e837a3a251caba5266e728839fc25f437da5ad962e991ff"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.6.0/locron-v0.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ebc2f548cd415901310834f0520efb5fdc4f8899593f2d9d423533cb0ab47f7a"
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
