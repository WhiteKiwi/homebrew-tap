class Locron < Formula
  desc "Local-first job scheduler for macOS and Linux"
  homepage "https://github.com/WhiteKiwi/locron"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.0/locron-v0.9.0-aarch64-apple-darwin.tar.gz"
      sha256 "d58a27d8cab980f0632f4427558b369aa37d31eb5ef3fd2916f4727bccd9e11e"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.0/locron-v0.9.0-x86_64-apple-darwin.tar.gz"
      sha256 "c4db62efe16b8c884d7c27dbc5be272aef47cedf8977b744b53a60e118a9660f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.0/locron-v0.9.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f689f3001120f41f09de74a36d48cc364f395f2d71cb14be0c64e6ccbe3f3f18"
    else
      url "https://github.com/WhiteKiwi/locron/releases/download/v0.9.0/locron-v0.9.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a1693d6b5d322395d44de8c3cb33483d80b9f069b6764c9a618366e850765caf"
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
