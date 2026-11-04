cask "mira" do
  version "0.9.3"
  sha256 "96c50a10a496e963c8660d01fd4321f1dfe82e1ab9fb3f7c26701ffd8e7ebb65"

  url "https://github.com/sasou-web/Mira/releases/download/v#{version}/Mira-#{version}-mac-arm64.dmg"
  name "Mira"
  desc "Jellyfin client with a built-in mpv player"
  homepage "https://miracinema.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "Mira.app"

  zap trash: [
    "~/Library/Application Support/Mira",
    "~/Library/Saved Application State/io.github.sasou-web.mira.savedState",
  ]

  caveats <<~EOS
    Mira is not signed by Apple yet, so macOS asks once before opening it:
      open Mira, choose Done, then System Settings > Privacy & Security >
      Open Anyway, and confirm with your password.
    Mira then updates itself, like the copy from the .dmg.
  EOS
end
