---
name: typst-delivery
description: Create a new Typst delivery (Abgabe, e.g. a new milestone report) or update an existing one in docs/deliveries/ — add or edit chapters, tables, figures and sources in quellen.bib, then verify it compiles. Use whenever the user wants to write, extend, restructure or fix PREN documentation.
---

# Typst delivery: create or update

Each delivery is `docs/deliveries/<name>/doc.typ` plus a `chapters/` folder. Everything shared (template, bibliography, assets, fonts) lives in `docs/library/`.

**Language:** all document text is German with Swiss orthography: `ss` instead of `ß`, quotes as «…», decimal point in numbers (`0.5 m/s`), `CHF 200.–`. Write in full sentences, factual report style. Do not invent technical facts, numbers, ratings or sources — ask the user or leave a visible `// TODO:` comment.

## Before you start

1. Read `docs/library/template.typ` (parameters of `pren-report`) and the existing delivery closest to the task (currently `docs/deliveries/milestone_1/`) to match structure and style.
2. Decide: **new delivery** or **update existing**. If unclear which delivery the user means, ask.

## A. New delivery

1. Folder name: lowercase snake_case, e.g. `milestone_2`. Create `docs/deliveries/<name>/doc.typ` and `docs/deliveries/<name>/chapters/`.
2. `doc.typ` skeleton — copy team/members/coach/logo from the latest delivery and ask the user for title, milestone and date:

   ```typst
   #import "../../library/template.typ": pren-report

   #show: pren-report.with(
     title: "Konzeptbericht Meilenstein 2",   // becomes the PDF filename – must be unique across deliveries
     module: "PREN1 – Produktentwicklung HS26",
     team: "Team 03",
     members: (...),                           // copy from latest delivery
     coach: "...",
     milestone: "Meilenstein 2",
     date: datetime(year: 2026, month: 11, day: 20),
     logo: image("../../library/assets/hslu-logo.png"),
   )

   #include "chapters/<kapitel>.typ"

   #bibliography("../../library/quellen.bib", title: "Quellenverzeichnis", style: "ieee")
   ```

3. Don't add `version` or `draft` — the build script injects them. Don't add a table of contents — the template generates it (plus figure/table lists when figures exist).
4. Nothing else needs registering: the build script and CI pick up every `deliveries/*/doc.typ`.
5. Content carried over from an earlier delivery: copy the chapter file into the new `chapters/` folder (deliveries must stay independently buildable and frozen once released — never `#include` across deliveries).
6. Remind the user that the PR should get the label `release:major` (new milestone delivery).

## B. Update an existing delivery

- **New chapter:** create `chapters/<thema>.typ` (lowercase, no umlauts), start with the header banner used in existing chapters, put chapter-local helper functions at the top, then content. Add `#include "chapters/<thema>.typ"` in `doc.typ` at the right position (before `#bibliography`). PR label: `release:minor`.
- **Edits/corrections:** change the chapter in place; keep existing labels stable since other chapters may reference them (`grep -rn '@<label>' docs/` before renaming). PR label: none (patch).
- Reuse existing helpers in that chapter (e.g. `tech-tabelle`, `bewertung`, `recherche`, `punkte` in `technologierecherche.typ`) instead of building tables by hand. If a helper is needed in a second chapter, copy it — don't create cross-chapter imports unless the user asks for a shared helper (then put it in `docs/library/`).

## Typst conventions (from the template)

- Headings: `=` starts a new page automatically (level 1 page-breaks), numbering is automatic. Use `#pagebreak()` sparingly to avoid orphaned tables.
- Labels: `<kap-…>` for chapters/sections, `<tab-…>` for tables, `<fig-…>` for figures. Reference with `@kap-…`; always reference a figure/table from the text before it appears.
- Tables: wrap in `#figure(table(...), caption: [...]) <tab-…>`. The template styles header row and strokes — don't add your own stroke/fill except group rows (`table.cell(colspan: n, fill: luma(235))`). Use `table.header(...)` so headers repeat across pages. Long tables: `#show figure: set block(breakable: true)` inside a `#[ ... ]` scope, and `set table.cell(breakable: false)`.
- Images: put the file in `docs/library/assets/` and use a path relative to the **file that contains the code** (from a chapter: `../../../library/assets/x.png`; from `doc.typ`: `../../library/assets/x.png`). Always `#figure(image(..., width: …%), caption: [...]) <fig-…>`.
- Citations: `@key` in text; multiple sources `@a @b`. The task description is cited as `@aufgabe`.

## Sources (`docs/library/quellen.bib`)

- Single bibliography shared by all deliveries — only add, never delete entries still cited by an older delivery (`grep -rn '@<key>' docs/deliveries/`).
- Group entries under the existing comment banners (`% ── <Thema> ───`); add a new banner for a new topic. Key style: short lowercase-hyphenated, `<source>-<thing>` (e.g. `reichelt-pi5`).
- Web sources:
  ```bib
  @online{shop-produkt,
    title  = {Exact page title},
    author = {{Company Name}},
    url    = {https://...},
  }
  ```
  Keep URLs real and complete — a weekly link checker opens an issue for broken ones.

## Verify (always)

Compile every delivery you touched, from the repo root:

```sh
typst compile --root docs --font-path docs/library/fonts --ignore-system-fonts \
  docs/deliveries/<name>/doc.typ /tmp/<name>.pdf
```

Or build all: `scripts/build-deliveries.sh` (output in `dist/`). Fix all errors; also read warnings (unknown citation keys, missing labels, font fallback). Check the PDF visually for tables split awkwardly or captions alone at page ends if possible. Never commit PDFs.

## Wrap-up

Summarise what changed and suggest the PR label (`release:major` new delivery · `release:minor` new chapters/content · none for corrections · `release:skip` for non-content changes). Versions are per delivery (tags `<name>/vX.Y.Z`): only deliveries whose folder the PR touches get a release, and the label applies to all of them — so keep changes to different deliveries in separate PRs when they need different bumps.
