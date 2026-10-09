cask "ewiz" do
  version "0.18.7"
  sha256 "96b63bd4dfb4fbc4d929606426b3827bdd7ebab0cf34a94951e1940c0585aa1f"

  url "https://github.com/stroke-app/ewiz/releases/download/v0.18.7/eWiz-0.18.7.dmg"
  name "eWiz"
  desc "Menu bar battery saver and charge limiter for Apple Silicon Macs"
  homepage "https://ewiz.app"

  depends_on macos: :sonoma
  depends_on arch: :arm64

  # eWiz installs signed updates itself; brew shouldn't treat that as drift.
  auto_updates true

  app "eWiz.app"

  # The app is signed ad-hoc (not notarized yet). Homebrew quarantines downloads
  # and no longer supports --no-quarantine, so clear the quarantine after install
  # to let the app launch without a Gatekeeper "damaged" warning.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/eWiz.app"]
  end

  caveats <<~EOS
    Charge limiting, Low Power Mode, and sleep controls need a small root helper
    (a LaunchDaemon). After first launch, open the eWiz menu-bar item and
    click "Install Helper" — you will be asked for your password once. The helper
    re-enables charging automatically if it ever stops.
  EOS

  uninstall quit: ["com.ewiz.app", "com.battlify.app"]

  zap trash: [
    "~/Library/Application Support/eWiz",
    "~/Library/Preferences/com.ewiz.app.plist",
    # From before the rename.
    "~/Library/Application Support/Battlify",
    "~/Library/Preferences/com.battlify.app.plist",
  ]
end
