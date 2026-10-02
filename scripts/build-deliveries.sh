#!/usr/bin/env bash
# Kompiliert alle Abgaben (docs/deliveries/*/doc.typ) zu PDFs.
#
#   scripts/build-deliveries.sh [--release] [VERSION] [OUTDIR]
#
#   --release  ohne «ENTWURF»-Wasserzeichen (nur für GitHub-Releases)
#   VERSION    erscheint im Dokument und im Dateinamen (Default: Entwurf)
#   OUTDIR     Zielordner (Default: dist)
#
# Dateiname wird aus dem Dokumenttitel abgeleitet, z. B.
#   Konzeptbericht-Meilenstein-1-Entwurf.pdf
# Bei --release wird zusätzlich «TEAM3» vorangestellt, z. B.
#   TEAM3-Konzeptbericht-Meilenstein-1-v1.2.0.pdf
set -euo pipefail

release=false
prefix=""
if [[ "${1:-}" == "--release" ]]; then
  release=true
  prefix="TEAM3-"
  shift
fi
version="${1:-Entwurf}"
outdir="${2:-dist}"

root="$(cd "$(dirname "$0")/.." && pwd)"
docs="$root/docs"
fonts="$docs/library/fonts"
typst_args=(--root "$docs" --font-path "$fonts" --ignore-system-fonts)

slugify() {
  sed -e 's/ä/ae/g; s/ö/oe/g; s/ü/ue/g; s/Ä/Ae/g; s/Ö/Oe/g; s/Ü/Ue/g; s/ß/ss/g' \
      -e 's/[^A-Za-z0-9._-]\{1,\}/-/g; s/^-//; s/-$//'
}

mkdir -p "$outdir"
for doc in "$docs"/deliveries/*/doc.typ; do
  title=$(typst query "${typst_args[@]}" "$doc" "<pren-title>" --field value --one | jq -r .)
  out="$outdir/${prefix}$(printf '%s' "$title" | slugify)-$(printf '%s' "$version" | slugify).pdf"
  typst compile "${typst_args[@]}" \
    --input version="$version" --input release="$release" \
    "$doc" "$out"
  echo "Built $out"
done
