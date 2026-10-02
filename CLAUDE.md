# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Typst documentation for the HSLU module PREN1 HS26 (Team 03, a dog-like robot). There is no application code. The deliverables are PDFs built from `docs/deliveries/<abgabe>/doc.typ`.

All document content, comments, and commit/PR text are in **Swiss German orthography**: use `ss` instead of `ß`, guillemets `«…»` for quotes, and `lang: "de", region: "ch"` (already set in the template).

## Commands

Requires Typst 0.14 (CI pins 0.14.2) and `jq`.

```sh
scripts/build-deliveries.sh                     # all deliveries as drafts ("ENTWURF" watermark) → dist/
scripts/build-deliveries.sh --release v1.2.0    # without watermark
scripts/build-deliveries.sh --release --only milestone_1 v1.2.0   # one delivery (what CI does for releases)

# Compile a single delivery (same flags as the script; --root is required because of ../../library imports)
typst compile --root docs --font-path docs/library/fonts --ignore-system-fonts \
  docs/deliveries/milestone_1/doc.typ /tmp/out.pdf
# Use `typst watch` with the same flags for live rebuilds.
```

There are no tests or linters. "Does it compile" is the check — the PR preview workflow fails if any delivery fails to compile. Always pass `--ignore-system-fonts --font-path docs/library/fonts` so output matches CI (Inter is vendored).

## Architecture

- `docs/library/` holds the shared pieces: `template.typ` (the `pren-report` show-rule), `quellen.bib` (single bibliography for all deliveries, IEEE style), `assets/`, `fonts/`.
- Each delivery's `doc.typ` applies `#show: pren-report.with(...)`, then writes content and `#include`s chapters from its `chapters/` folder. Chapters are included, not imported, so they share the doc's context; paths inside chapters are relative to the chapter file (e.g. `../../../library/assets/...`).
- Chapter-local helper functions live at the top of the chapter file (e.g. `tech-tabelle`, `bewertung`, `recherche` in `technologierecherche.typ`). Reuse them rather than hand-building tables.
- Template ↔ build script contract:
  - The template emits `#metadata(title) <pren-title>`; the build script reads it via `typst query` to derive the PDF filename (umlauts transliterated, slugified; release builds get a `TEAM3-` prefix). Don't remove that label.
  - `version` and `release` come in via `sys.inputs` (`--input version=… --input release=true`). `release != "true"` → draft watermark.
- Template conventions: captions sit below both tables and figures; Abbildungs- and Tabellenverzeichnis are generated automatically at the end of the document (after the Quellenverzeichnis), only when such figures exist; front matter uses roman page numbers, body arabic. Label references like `<kap-…>`, `<tab-…>`, `<fig-…>`.
- Adding a new delivery = new folder `docs/deliveries/<name>/doc.typ`; the build script and CI pick up every `deliveries/*/doc.typ` automatically.

## CI / Releases (`.github/workflows/`)

- **preview-deliveries**: on every PR to `main`, builds draft PDFs and comments a download link on the PR.
- **release-deliveries**: versioned **per delivery**. On merged PRs, for each delivery whose folder `docs/deliveries/<name>/` the PR touched, creates a GitHub release tagged `<name>/vX.Y.Z` with that delivery's watermark-free PDF (built via `build-deliveries.sh --only <name>`). Changes only in `docs/library/` trigger no release. Bump is controlled by PR label and applies to all touched deliveries: `release:major` (new milestone delivery; first release → `v1.0.0`), `release:minor` (new chapters/content), none → patch (corrections), `release:skip` → no release. Also runnable via `workflow_dispatch` (delivery + bump).
- **check-links**: weekly lychee run over `docs/**/*.bib` and `docs/**/*.typ`; broken links are collected in one GitHub issue. 403/429 are accepted because shops block bots.

`dist/` and `docs/**/*.pdf` are gitignored — never commit PDFs.

## Writing or changing documentation

Use the project skill `/typst-delivery` (`.claude/skills/typst-delivery/SKILL.md`) for creating a new delivery or updating chapters, tables, figures and sources.
