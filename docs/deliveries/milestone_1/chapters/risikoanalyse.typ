// ─────────────────────────────────────────────────────────────
//  Kapitel: Risikoanalyse
//  Wird in «doc.typ» per #include eingebunden.
//  Die Tabelle wird laufend ergänzt: neue Risiken unten in
//  «risiko-tabelle» eintragen, die Risikozahl wird automatisch
//  berechnet.
// ─────────────────────────────────────────────────────────────

// ── Hilfsfunktionen ──────────────────────────────────────────

// Risikozahl R = W × A als farbiges Badge (1–9), none = nicht bewertet
#let risikozahl(w, a) = {
  if w == none or a == none { return text(fill: luma(150))[–] }
  let r = w * a
  let c = if r >= 6 { rgb("#b91c1c") } else if r >= 3 { rgb("#b45309") } else { rgb("#15803d") }
  box(
    fill: c.lighten(88%),
    stroke: 0.5pt + c.lighten(60%),
    inset: (x: 5pt, y: 3pt),
    radius: 3pt,
    text(fill: c, weight: "bold", size: 8.5pt, str(r)),
  )
}

// Kompakte Massnahmenliste
#let punkte(items) = {
  if items.len() == 0 { return text(fill: luma(150))[–] }
  grid(
    columns: (0.8em, 1fr),
    row-gutter: 0.45em,
    ..items.map(i => (text(weight: "bold", "-"), i)).flatten()
  )
}

// Risikotabelle
// Zeile: (nr, funktion, name, text, massnahmen: (..), w, a)
//   funktion: betroffener Funktionsbereich aus der Funktionszerlegung
//   w: Eintrittswahrscheinlichkeit 1–3, a: Auswirkung 1–3 (weglassen = noch nicht bewertet)
// Seitenumbruch: Show-Regel unten im Kapitel (sonst lässt sich kein Label anhängen)
#let risiko-tabelle(caption, ..zeilen) = figure(
  kind: table,
  caption: caption,
  {
    set text(size: 8.5pt)
    set par(justify: false, leading: 0.5em)
    // Zeilen nicht über Seitenumbruch zerreissen
    set table.cell(breakable: false)
    table(
      columns: (0.9cm, 3.2cm, 1fr, 1fr, auto, auto, auto),
      align: (x, _) => if x >= 4 { center + horizon } else { left + top },
      table.header([Nr.], [Funktion], [Risiko], [Massnahmen], [W], [A], [R]),
      ..if zeilen.pos().len() == 0 {
        (table.cell(colspan: 7, align: center)[_Wird laufend ergänzt._],)
      } else {
        zeilen.pos().map(z => {
          let w = z.at("w", default: none)
          let a = z.at("a", default: none)
          (
            [#z.nr],
            z.funktion,
            [*#z.name* #if z.at("text", default: none) != none { linebreak(); z.text }],
            punkte(z.at("massnahmen", default: ())),
            if w == none [–] else [#w],
            if a == none [–] else [#a],
            risikozahl(w, a),
          )
        }).flatten()
      },
    )
  },
)

// ─────────────────────────────────────────────────────────────

= Risikoanalyse <kap-risikoanalyse>

Die Risikoanalyse erfasst die Risiken, die den Projekterfolg gefährden können, und legt Massnahmen fest, um deren Eintrittswahrscheinlichkeit oder Auswirkung zu verringern. Sie wird im Verlauf des Projekts laufend ergänzt und neu bewertet. Dieses Kapitel zeigt den Stand zum Zeitpunkt der Abgabe.

Jedes Risiko ist einem Funktionsbereich der Funktionszerlegung (@kap-technologie) zugeordnet. Risiken, die keinen einzelnen Funktionsbereich betreffen, etwa zu Terminen, Budget oder Zusammenarbeit, sind als «Projekt» erfasst. Bewertet wird jedes Risiko nach seiner Eintrittswahrscheinlichkeit (W) und seiner Auswirkung (A) auf einer Skala von 1 bis 3 (@tab-risiko-skala). Das Produkt ergibt die Risikozahl R = W × A. Risiken mit einer Risikozahl ab 6 gelten als hoch und werden prioritär behandelt. Die erfassten Risiken sind in @tab-risikoanalyse aufgeführt.

#figure(
  {
    set par(justify: false)
    table(
      columns: (auto, 1fr, 1fr),
      align: left + top,
      table.header([Wert], [Eintrittswahrscheinlichkeit (W)], [Auswirkung (A)]),
      [1], [gering – Eintritt unwahrscheinlich], [gering – kaum Einfluss auf Termine, Kosten oder Funktion],
      [2], [mittel – Eintritt möglich], [mittel – Mehraufwand, Ziele bleiben erreichbar],
      [3], [hoch – Eintritt wahrscheinlich], [hoch – Anforderung oder Meilenstein gefährdet],
    )
  },
  caption: [Bewertungsskala der Risikoanalyse],
) <tab-risiko-skala>


#align(center)[
  #set text(size: 8.5pt)
  #grid(
    columns: 4,
    column-gutter: 1.4em,
    align: horizon,
    [#risikozahl(3, 2) #h(0.2em) 6–9: hoch],
    [#risikozahl(1, 3) #h(0.2em) 3–4: mittel],
    [#risikozahl(1, 2) #h(0.2em) 1–2: gering],
    [#risikozahl(none, none) #h(0.2em) nicht bewertet],
  )
]


// Risikotabelle darf über mehrere Seiten umbrechen
#show figure.where(kind: table): set block(breakable: true)

// Neue Risiken hier ergänzen, z. B.:
//   (
//     nr: [R01], funktion: [Energieversorgung],
//     name: [Titel], text: [Ursache und Auswirkung],
//     massnahmen: ([Massnahme 1], [Massnahme 2]),
//     w: 2, a: 3,
//   ),
// TODO: W und A durch das Team bewerten
#risiko-tabelle(
  [Risikoanalyse (Stand Meilenstein 1)],
  (
    nr: [R01], funktion: [Rechenplattform],
    name: [Zu wenig Rechenleistung des Raspberry Pi 4],
    text: [Der Raspberry Pi 4 ist nicht für KI-Anwendungen ausgelegt. Laufen Objekt-, Gesten- und Spracherkennung gleichzeitig, reicht die Rechenleistung möglicherweise nicht aus, und die Zeitvorgaben im Wettbewerb können nicht eingehalten werden.],
    massnahmen: ([Auslastung früh mit einem Prototyp messen], [Rechenintensive Aufgaben auslagern, z. B. auf eine KI-Kamera], [Raspberry Pi 5 als Alternative vorsehen]),
    w: 2,
    a:2
  ),
  (
    nr: [R02], funktion: [Objekterkennung],
    name: [Zu hohe Kosten durch Kameras],
    text: [Werden mehrere oder spezialisierte Kameras (KI-, Tiefen- oder Stereokamera) eingesetzt, wird ein grosser Teil des Budgets von CHF~200.– in PREN1 aufgebraucht.],
    massnahmen: ([Anzahl Kameras auf das Nötigste beschränken], [Günstige RGB-Kamera bevorzugen, wo sie ausreicht], [Kosten laufend im Budget nachführen]),
    w: 2,
    a:1
  ),
  (
    nr: [R03], funktion: [Fortbewegung],
    name: [Zu hohes Gewicht durch viele Motoren],
    text: [Jeder zusätzliche Motor erhöht Gewicht, Energiebedarf und mechanische Komplexität. Das maximale Gewicht von 7~kg kann überschritten werden.],
    massnahmen: ([Anzahl Motoren im Konzept minimieren], [Gewichtsbilanz früh erstellen und laufend nachführen], [Leichte Motoren und Leichtbau bevorzugen]),
    w: 1,
    a:2
  ),
  (
    nr: [R04], funktion: [Audio-Erfassung],
    name: [Ungenügende Mikrofonqualität],
    text: [Ist das Mikrofon zu wenig empfindlich oder nimmt es zu viele Störgeräusche (z. B. der eigenen Motoren) auf, werden die Sprachbefehle auf 0.5–2~m Abstand nicht zuverlässig erkannt.],
    massnahmen: ([Mikrofon früh unter realistischen Bedingungen testen], [Mikrofon entfernt von Motoren platzieren], [Filterung bzw. Signalverarbeitung vorsehen]),
    w: 1,
    a: 2
  ),
  (
    nr: [R05], funktion: [Material und Design],
    name: [Gewinde in Kunststoff],
    text: [Direkt in 3D-gedruckten Kunststoff geschnittene Gewinde halten wenig Belastung aus und verschleissen bei wiederholtem Montieren. Verbindungen können sich lösen oder ausreissen.],
    massnahmen: ([Gewindeeinsätze aus Metall oder Mutterntaschen vorsehen], [Anzahl lösbarer Verbindungen in Kunststoff minimieren]),
    w: 1,
    a: 3
  ),
  (
    nr: [R06], funktion: [Audio-Erfassung, Video-Erfassung],
    name: [Ortung],
    text: [Die Richtung, aus der ein Befehl gesprochen wird, lässt sich möglicherweise nicht zuverlässig bestimmen, etwa wegen Umgebungslärm, ungünstiger Mikrofonanordnung oder falsche Richtung der Kameras.],
    massnahmen: ([Machbarkeit früh mit mehreren Mikrofonen testen], [Ausweichlösung über Kamera (Person erkennen) vorsehen]),
    w: 2,
    a: 2
  ),

) <tab-risikoanalyse>
