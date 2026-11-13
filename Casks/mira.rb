cask "mira" do
  version "0.9.8"
  sha256 "8472941d3c6230094d5fb4b2688947b9755e5f58baa3a39f18f5e05e8b8c67d1"

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
