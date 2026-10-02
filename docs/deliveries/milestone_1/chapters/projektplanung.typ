// ─────────────────────────────────────────────────────────────
//  Kapitel: Projektplanung
//  Quelle: Projektunterlagen/Planung/Projektplan_v1.xlsx (SharePoint)
//  Wird in «doc.typ» per #include eingebunden.
// ─────────────────────────────────────────────────────────────

// ── Hilfsfunktionen ──────────────────────────────────────────

// Anzahl Arbeitstage im Plan: SW0 bis SW14 à 5 Tage
#let plan-tage = 75
#let plan-wochen = 15

// Zeitachse einer Zeile: Balken (Start- und Endtag, 0-basiert ab Montag SW0)
// und optional ein Meilenstein-Symbol an einem Tag
#let zeitachse(..bereiche, farbe: luma(130), meilenstein: none) = box(width: 100%, height: 0.75em, {
  for w in range(1, plan-wochen) {
    place(dx: w / plan-wochen * 100%, dy: -0.25em, line(angle: 90deg, length: 1.25em, stroke: 0.3pt + luma(205)))
  }
  for b in bereiche.pos() {
    place(
      dx: b.at(0) / plan-tage * 100%,
      rect(width: (b.at(1) - b.at(0) + 1) / plan-tage * 100%, height: 100%, fill: farbe, stroke: none),
    )
  }
  if meilenstein != none {
    place(
      dx: (meilenstein + 0.5) / plan-tage * 100% - 0.3em,
      dy: 0.05em,
      rotate(45deg, square(size: 0.45em, fill: black)),
    )
  }
})

// Phasen-Zeile über alle Spalten
#let phase(titel) = table.cell(colspan: 4, fill: luma(235))[*#titel*]

// Meilenstein-Bezeichnung
#let meilenstein(titel) = table.cell(colspan: 2)[_#titel _]

// ─────────────────────────────────────────────────────────────

= Projektplanung <kap-projektplanung>

Die Projektplanung gliedert PREN1 in vier Phasen, die jeweils mit einem Meilenstein abschliessen. Die Phasen sind in Arbeitspakete und Aufgaben unterteilt, denen jeweils verantwortliche Teammitglieder zugeordnet sind. Geplant wird in Semesterwochen (SW). Der Projektplan wird im Team laufend nachgeführt. Dieses Kapitel zeigt den Stand zum Zeitpunkt der Abgabe. @tab-meilensteine fasst die Meilensteine zusammen, @tab-projektplan zeigt den detaillierten Zeitplan.

Der Projektplan wurde in einem Excel erstellt und ist #link("https://hsluzern.sharepoint.com/:x:/s/PRENGruppe3-TM/IQCHW3WYhfx-RL7dXSMNYzVLAcJUqzcVjKV8o47l0wG6n3c?e=6x2jQG")[hier] zu finden.#footnote[#link("https://hsluzern.sharepoint.com/:x:/s/PRENGruppe3-TM/IQCHW3WYhfx-RL7dXSMNYzVLAcJUqzcVjKV8o47l0wG6n3c?e=6x2jQG")]

#figure(
  {
    set par(justify: false)
    table(
      columns: (auto, auto, 1fr),
      align: left + top,
      table.header([Meilenstein], [Datum], [Inhalt]),
      [Meilenstein 1], [02.10.2026], [Projektplanung: Risiken, Modell der Aufgabenstellung, Anforderungsliste, Technologierecherche],
      [Meilenstein 2], [30.10.2026], [Evaluation und Lösungsfindung: Anforderungsliste, Lösungsvarianten, Nutzwertanalyse, Risikoanalyse],
      [Meilenstein 3], [04.12.2026], [Freigabe Gesamtkonzept: Simulation, Dokumentation zu 80 %],
      [Schlussbericht], [08.01.2027], [Dokumentation],
    )
  },
  caption: [Meilensteine PREN1],
) <tab-meilensteine>

// Querformat, damit der Zeitplan lesbar bleibt
#[
  #set page(flipped: true)
  #show figure: set block(breakable: true)

  #figure(
    {
      set text(size: 8pt)
      set par(justify: false, leading: 0.45em)
      set table.cell(breakable: false)
      table(
        columns: (auto, 5.4cm, 5.6cm, 1fr),
        inset: (x: 5pt, y: 3.5pt),
        align: (x, _) => left + horizon,
        table.header(
          [Nr.], [Arbeitspaket / Aufgabe], [Verantwortlich],
          [
            #grid(
              columns: (1fr,) * plan-wochen,
              ..range(plan-wochen).map(w => align(center, text(size: 7pt)[SW#w])),
            )
          ],
        ),
      phase[Phase 1 – Projektplanungs- und Recherchephase],
      [*1.1*], [*Projektplanung*], [], zeitachse(farbe: luma(40)),
      [1.1.1], [Arbeitsbereiche/Organigramm], [Eric Frick], zeitachse((9, 9), (14, 18)),
      [1.1.2], [Skizzierung/ Modell der Aufgabenstellung], [Samuel Felder], zeitachse((15, 18)),
      [1.1.3], [Anforderungsliste], [Eric Frick], zeitachse((10, 18)),
      [1.1.4], [Funktionszerlegung], [alle], zeitachse((14, 18)),
      [*1.2*], [*Technologierecherche nach Funktionszerlegung*], [], zeitachse(farbe: luma(40)),
      [1.2.01], [Energie], [Eric Frick], zeitachse((14, 19)),
      [1.2.02], [Rechenplattform], [Erin Bachmann, Cédric Gerber], zeitachse((14, 19)),
      [1.2.03], [Steuerung], [Eric Frick, Samuel Felder], zeitachse((14, 19)),
      [1.2.04], [Fortbewegung], [Lee Kürsener, Erin Bachmann, Samuel Felder, Jan Grisiger], zeitachse((14, 19)),
      [1.2.05], [Simulator], [Cédric Gerber, Erin Bachmann], zeitachse((14, 19)),
      [1.2.06], [Navigation], [Cédric Gerber, Erin Bachmann], zeitachse((14, 19)),
      [1.2.07], [Reaktion/Emotion], [Eric Frick, Jan Grisiger, Lee Kürsener], zeitachse((14, 19)),
      [1.2.08], [Sprachsteuerung], [Samuel Felder, Cédric Gerber], zeitachse((14, 19)),
      [1.2.09], [Objekterkennung], [Cédric Gerber, Erin Bachmann], zeitachse((14, 19)),
      [1.2.10], [Kommunikationsschnittstelle], [Eric Frick, Samuel Felder], zeitachse((14, 19)),
      [1.2.11], [Material/Design], [Lee Kürsener, Jan Grisiger], zeitachse((14, 19)),
      [*1.3*], [*Abgabe der Datei Meilenstein 1 (18:00 Uhr)*], [Erin Bachmann], zeitachse((19, 19), farbe: luma(40)),
      meilenstein[Meilenstein 1], [02.10.2026], zeitachse(meilenstein: 19),
      phase[Phase 2 – Evaluations- und Lösungsfindungsphase],
      [*2.1*], [*Evaluation der Lösungsansätze*], [], zeitachse((19, 34), farbe: luma(40)),
      [2.1.01], [Energie], [Eric Frick], zeitachse((19, 34)),
      [2.1.02], [Rechenplattform], [alle], zeitachse((19, 34)),
      [2.1.03], [Steuerung], [alle], zeitachse((19, 34)),
      [2.1.04], [Fortbewegung], [alle], zeitachse((19, 34)),
      [2.1.05], [Simulator], [alle], zeitachse((19, 34)),
      [2.1.06], [Navigation], [alle], zeitachse((19, 34)),
      [2.1.07], [Reaktion/Emotion], [alle], zeitachse((19, 34)),
      [2.1.08], [Sprachsteuerung], [alle], zeitachse((19, 34)),
      [2.1.09], [Objekterkennung], [alle], zeitachse((19, 34)),
      [2.1.10], [Kommunikationsschnittstelle], [alle], zeitachse((19, 34)),
      [2.1.11], [Material/Design], [alle], zeitachse((19, 34)),
      [*2.2*], [*Auswahl Lösungsvarianten*], [], zeitachse(farbe: luma(40)),
      [2.2.1], [Morphologischer Kasten], [offen], zeitachse((23, 38)),
      [2.2.2], [Nutzwertanalyse], [offen], zeitachse((23, 38)),
      [2.2.3], [Risikoanalyse], [offen], zeitachse((23, 38)),
      [*2.3*], [*Abgabe der Datei Meilenstein 2 (18:00 Uhr)*], [Erin Bachmann], zeitachse((39, 39), farbe: luma(40)),
      meilenstein[Meilenstein 2], [30.10.2026], zeitachse(meilenstein: 39),
      phase[Phase 3 – Konzeptionierungsphase],
      [], [*Abgabe der Datei Meilenstein 3 (18:00 Uhr)*], [Erin Bachmann], zeitachse((64, 64), farbe: luma(40)),
      meilenstein[Meilenstein 3], [04.12.2026], zeitachse(meilenstein: 64),
      phase[Phase 4 – Schlussphase PREN1],
      meilenstein[Abgabe Schlussbericht], [08.01.2027], zeitachse(),
      )
    },
    caption: [Zeitplan PREN1 (Stand Meilenstein 1)],
  ) <tab-projektplan>
]
