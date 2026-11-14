cask "mira" do
  version "0.9.9"
  sha256 "97868e9bf0203a2b3d8b92a890d96cb34155c17d311c6a4e038c8f7d63ba4a66"

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
