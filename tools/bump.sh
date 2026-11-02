#!/bin/sh
# Points Casks/mira.rb at the latest published release of sasou-web/Mira, after checking the image's SHA-256 three
# ways: the bytes downloaded here, the .sha256 file published beside the image and the digest GitHub keeps for the
# asset. Prints the new version, or nothing when the cask is already current. Needs curl, jq and shasum or sha256sum.
set -eu
CASK="${1:-Casks/mira.rb}"
API="https://api.github.com/repos/sasou-web/Mira/releases/latest"
auth=""; [ -n "${GITHUB_TOKEN:-}" ] && auth="Authorization: Bearer $GITHUB_TOKEN"
release=$(curl -fsSL ${auth:+-H "$auth"} "$API")
tag=$(printf '%s' "$release" | jq -r '.tag_name')
version=${tag#v}
case "$version" in *[!0-9.]*|"") echo "unexpected tag: $tag" >&2; exit 1;; esac
current=$(sed -n 's/^  version "\(.*\)"$/\1/p' "$CASK")
[ "$current" = "$version" ] && exit 0
image="Mira-$version-mac-arm64.dmg"
digest=$(printf '%s' "$release" | jq -r --arg n "$image" '.assets[] | select(.name == $n) | .digest // empty')
[ -n "$digest" ] || { echo "$image is not in $tag" >&2; exit 1; }
work=$(mktemp -d); trap 'rm -rf "$work"' EXIT
base="https://github.com/sasou-web/Mira/releases/download/$tag"
curl -fsSL -o "$work/$image" "$base/$image"
curl -fsSL -o "$work/$image.sha256" "$base/$image.sha256"
if command -v sha256sum >/dev/null; then sum=$(sha256sum "$work/$image" | cut -d' ' -f1); else sum=$(shasum -a 256 "$work/$image" | cut -d' ' -f1); fi
published=$(cut -d' ' -f1 < "$work/$image.sha256")
[ "$sum" = "$published" ] || { echo "$image: $sum, its .sha256 says $published" >&2; exit 1; }
[ "sha256:$sum" = "$digest" ] || { echo "$image: $sum, GitHub says $digest" >&2; exit 1; }
sed -i.bak -e "s/^  version \".*\"$/  version \"$version\"/" -e "s/^  sha256 \".*\"$/  sha256 \"$sum\"/" "$CASK"
rm -f "$CASK.bak"
echo "$version"
