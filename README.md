# Homebrew tap for Mira

[Mira](https://github.com/sasou-web/Mira) is a Jellyfin client for Windows and Mac with a built-in mpv player. This tap installs Mira for Mac (Apple silicon, macOS 15 or later):

```sh
brew install --cask sasou-web/mira/mira
```

**First launch.** Mira is not signed by Apple yet, so macOS asks once: open Mira, choose **Done**, then **System Settings → Privacy & Security → Open Anyway**, and confirm. Homebrew keeps macOS's protection as it is; nothing is bypassed.

**Updates.** Mira updates itself, from the same signed manifest as its Windows version. `brew upgrade --cask --greedy mira` also works.

**Uninstall.** `brew uninstall --cask mira`; add `--zap` to also delete Mira's settings and caches (`~/Library/Application Support/Mira`).

## How this tap is kept current

`bump.yml` checks the [releases of Mira](https://github.com/sasou-web/Mira/releases) every 3 hours. `tools/bump.sh` downloads the new image and only moves the cask when its SHA-256 matches both the `.sha256` file published with it and the digest GitHub keeps for the asset; releases of Mira are immutable. `test.yml` then installs the cask on a GitHub-hosted Mac, checks the app and removes it.

Mira is not in the official `homebrew/cask` yet: it requires apps notarised by Apple and a more notable repository.
