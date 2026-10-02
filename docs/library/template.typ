// ─────────────────────────────────────────────────────────────
//  PREN-Vorlage – HSLU Technik & Architektur
// ─────────────────────────────────────────────────────────────

#let pren-report(
  title: "Titel",
  subtitle: none,
  module: "PREN1 – Produktentwicklung",
  team: none,
  members: (),
  coach: none,
  milestone: none,
  date: datetime.today(),
  // Werden von scripts/build-deliveries.sh via `--input` gesetzt
  version: sys.inputs.at("version", default: "Entwurf"),
  draft: sys.inputs.at("release", default: "false") != "true",
  logo: none,
  accent: rgb("#1f2937"),
  font: "Inter", // liegt in library/fonts
  body,
) = {
  let date-str = if type(date) == datetime { date.display("[day].[month].[year]") } else { date }

  set document(title: title + " (" + version + ")", author: members)
  set text(lang: "de", region: "ch", font: font, size: 10.5pt)
  set par(justify: true, leading: 0.7em, spacing: 1.2em)
  set page(paper: "a4", margin: (x: 2.5cm, top: 3cm, bottom: 2.5cm))

  // Titel für Build-Skript (Dateiname der PDFs)
  [#metadata(title) <pren-title>]

  // ── Entwurfs-Wasserzeichen (nur ausserhalb von Releases) ───
  set page(background: if draft {
    rotate(-45deg, text(size: 90pt, weight: "bold", fill: rgb("#00000005"), tracking: 0.1em)[ENTWURF])
  })

  // ── Überschriften ──────────────────────────────────────────
  set heading(numbering: "1.1")
  show heading: set text(fill: accent, weight: "semibold")
  show heading.where(level: 1): it => {
    if it.outlined { pagebreak(weak: true) }
    v(0.5em)
    block(below: 1.35em, {
      set text(size: 20pt)
      if it.numbering != none [#counter(heading).display() #h(0.6em)]
      it.body
    })
  }
  show heading.where(level: 2): set text(size: 13pt)
  show heading.where(level: 2): set block(above: 1.6em, below: 0.8em)
  show heading.where(level: 3): set text(size: 11pt)

  // ── Abbildungen & Tabellen ─────────────────────────────────
  show figure.caption: set text(size: 9pt)
  show figure.caption: it => [*#it.supplement #context it.counter.display(it.numbering):* #it.body]
  set table(
    stroke: (_, y) => if y == 0 { (bottom: 0.8pt + accent) } else { (bottom: 0.4pt + luma(220)) },
    inset: (x: 8pt, y: 6pt),
    align: left,
  )
  show table.cell.where(y: 0): set text(weight: "semibold")

  // ── Diverses ───────────────────────────────────────────────
  show link: set text(fill: accent.lighten(20%))
  show raw.where(block: true): block.with(fill: luma(245), inset: 10pt, radius: 3pt, width: 100%)
  set list(indent: 0.8em)
  set enum(indent: 0.8em)

  // ── Titelseite ─────────────────────────────────────────────
  page(margin: (x: 2.5cm, y: 2.5cm), header: none, footer: none)[
    #if logo != none { box(height: 1.6cm, logo) }
    #v(1fr)
    #text(size: 11pt, fill: luma(110), tracking: 0.08em, upper(module))
    #v(0.2em)
    #text(size: 30pt, weight: "bold", fill: accent, title)
    #if subtitle != none {
      v(0.2em)
      text(size: 15pt, fill: luma(80), subtitle)
    }
    #v(1fr)
    #let row(k, v) = (text(fill: luma(110), k), v)
    #grid(
      columns: (3.5cm, 1fr),
      row-gutter: 2em,
      ..if team != none { row("Team", team) },
      ..if members.len() > 0 { row("Mitglieder", members.join(linebreak())) },
      ..if coach != none { row("Betreuung", coach) },
      ..if milestone != none { row("Abgabe", milestone) },
      ..row("Version", version),
      ..row("Datum", date-str),
    )
    #v(1.5cm)
    #text(size: 9pt, fill: luma(130))[Hochschule Luzern – Technik & Architektur]
  ]

  // ── Kopf- & Fusszeile ──────────────────────────────────────
  set page(
    header: context {
      grid(
        columns: (auto, 1fr),
        align: (left + horizon, right + horizon),
        if logo != none { box(height: 0.8cm, logo) },
        text(size: 8.5pt, fill: luma(110), title),
      )
      v(-0.3em)
      line(length: 100%, stroke: 0.4pt + luma(200))
    },
    footer: context {
      set text(size: 8.5pt, fill: luma(110))
      grid(
        columns: (1fr, 1fr),
        align: (left, right),
        [#module · #version],
        counter(page).display(page.numbering),
      )
    },
  )

  // ── Verzeichnisse (römisch nummeriert) ─────────────────────
  set page(numbering: "I")
  counter(page).update(1)

  {
    show outline.entry.where(level: 1): set block(above: 1.1em)
    show outline.entry.where(level: 1): set text(weight: "semibold")
    outline(title: "Inhaltsverzeichnis", indent: auto)
  }

  // ── Hauptteil (arabisch nummeriert) ────────────────────────
  set page(numbering: "1")
  counter(page).update(1)

  body

  // ── Abbildungs- & Tabellenverzeichnis (am Dokumentende) ────
  context {
    if query(figure.where(kind: image)).len() > 0 {
      heading(numbering: none)[Abbildungsverzeichnis]
      outline(title: none, target: figure.where(kind: image))
    }
    if query(figure.where(kind: table)).len() > 0 {
      heading(numbering: none)[Tabellenverzeichnis]
      outline(title: none, target: figure.where(kind: table))
    }
  }
}
