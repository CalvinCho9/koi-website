#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Pull all KOI image assets from Wix's CDN at full resolution.
#
# Wix serves every image through a transform URL like:
#   https://static.wixstatic.com/media/<ID>/v1/fill/w_153,h_70,.../<file>
# The bit after "/v1/" is a resize/crop. Stripping it and requesting just:
#   https://static.wixstatic.com/media/<ID>
# returns the ORIGINAL upload at full resolution. That's what we grab here.
#
# Usage:  bash scripts/download-assets.sh
# Reads:  assets-manifest.csv   (local_filename,wix_media_id)
# Writes: assets/<local_filename>
# ---------------------------------------------------------------------------
set -euo pipefail

cd "$(dirname "$0")/.."          # run from project root regardless of cwd
mkdir -p assets

MANIFEST="assets-manifest.csv"
BASE="https://static.wixstatic.com/media"
ok=0; fail=0

# skip header, read each row
tail -n +2 "$MANIFEST" | while IFS=, read -r name id; do
  [ -z "${name:-}" ] && continue
  url="${BASE}/${id}"
  printf "→ %-26s " "$name"
  if curl -fsSL -A "Mozilla/5.0" "$url" -o "assets/${name}"; then
    bytes=$(wc -c < "assets/${name}")
    echo "ok (${bytes} bytes)"
    ok=$((ok+1))
  else
    echo "FAILED — fetch manually: $url"
    fail=$((fail+1))
  fi
done

echo
echo "Done. Files saved to ./assets/"
echo "If any failed, open the URL in a browser and save it by hand,"
echo "or grab a sized version by re-adding e.g. /v1/fill/w_900/<file> to the URL."
