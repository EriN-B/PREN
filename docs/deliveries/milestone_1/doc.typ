#import "../../library/template.typ": pren-report

#show: pren-report.with(
  title: "Konzeptbericht Meilenstein 1",
  module: "PREN1 – Produktentwicklung HS26",
  team: "Team 03",
  members: ("Frick Eric Alexander", "Gerber Cédric", "Felder Samuel Sven", "Grisiger Jan Luca", "Kürsener Lee" ,"Erin Bachmann"),
  coach: "Markus Thalmann",
  milestone: "Meilenstein 1",
  date: datetime(year: 2026, month: 10, day: 2),
  logo: image("../../library/assets/hslu-logo.png"),
)

#include "chapters/gruppenorganisation.typ"

#include "chapters/projektplanung.typ"

= Anforderungsliste <kap-anforderungen>

Die Anforderungsliste wurde auf Grundlage der Aufgabenstellung @aufgabe erarbeitet und ist in sechs Themengebiete gegliedert: das Gerät selbst, den Wettbewerb, das Budget, Datenschutz und gesellschaftliche Aspekte, Material und Maschinennutzung sowie die Simulation. Jede Anforderung ist einer der folgenden Kategorien zugeordnet:

- *F – Festanforderung:* muss zwingend erfüllt werden.
- *M – Mindestanforderung:* muss mindestens im angegebenen Umfang erfüllt werden.
- *W – Wunsch:* soll nach Möglichkeit berücksichtigt werden.

Zusätzlich ist pro Anforderung festgehalten, welche Fachrichtung für deren Umsetzung verantwortlich ist (M = Maschinentechnik, Et = Elektrotechnik, I = Informatik). Die vollständige Anforderungsliste ist in @tab-anforderungen dargestellt.

#[
  // Gruppenzeile über alle Spalten
  #let gruppe(titel) = table.cell(colspan: 5, fill: luma(235))[*#titel*]
  // Lange Tabelle darf über mehrere Seiten umbrechen
  #show figure: set block(breakable: true)
  #figure(
    {
      set text(size: 9pt)
      set par(justify: false, leading: 0.55em)
      set table.cell(breakable: false)
      table(
        columns: (auto, auto, 3.6cm, 1fr, auto),
        align: (x, _) => if x == 1 or x == 4 { center + top } else { left + top },
        table.header([Nr.], [Kat.], [Bezeichnung], [Werte / Daten / Erläuterung], [Verantw.]),

        gruppe[1 Gerät (Hunde-Roboter)],
        [1.01], [M], [Maximale Geräteabmessung], [B = 20 cm, L = 50 cm, H = 50 cm (im Startzustand); \ L = 1 m (in Aktion)], [M],
        [1.02], [M], [Maximales Gewicht], [7 kg], [M],
        [1.03], [F], [Autonomie], [Autonomer Roboter, ohne Internetverbindung], [Et, I],
        [1.04], [F], [Selbständige Fortbewegung], [Fortbewegung in der Ebene; Fortbewegung über Räder ist zulässig], [alle],
        [1.05], [W], [Design], [Tragbarer, hundeähnlicher Roboter], [M, Et],
        [1.06], [F], [Spannungsversorgung], [Netzunabhängig], [Et],
        [1.07], [F], [Not-Stopp], [Physischer Not-Stopp, von aussen am Chassis zugänglich], [M, Et],
        [1.08], [M], [Objekterkennung (visuelle Suchfunktion)], [Knochen muss in einem definierten Bereich gefunden werden], [Et, I],
        [1.09], [M], [Gestenerkennung], [Erkennen von definierten Handgesten], [Et, I],
        [1.10], [M], [Sprachsteuerung], [Erkennen von definierten akustischen Befehlen], [Et, I],
        [1.11], [M], [Sitzende und liegende Position], [«Sitz» und «Platz» müssen ausgeführt werden können], [alle],
        [1.12], [M], [Emotionen (akustisch/visuell)], [Roboter reagiert mit einer akustisch oder visuell erkennbaren Reaktion auf Befehle], [alle],
        [1.13], [W], [Kunststück], [Roboter kann ein Kunststück ausführen], [alle],
        [1.14], [W], [Geschwindigkeit], [Fahrgeschwindigkeit des Roboters 0.5 m/s], [M, Et],

        gruppe[2 Wettbewerb],
        [2.01], [M], [Start der Suchfunktion], [Über Taster am Gerät oder Sprachbefehl «Such»], [alle],
        [2.02], [F], [Objekterkennung (visuelle Suchfunktion)], [Knochen im Suchfeld finden (Kreissegment 30°, r = 5 m)], [alle],
        [2.03], [M], [Zeitvorgabe], [Knochen finden: max. 2 min; «Sitz», «Platz» und «Auf»: max. 1 min; Kunststück: max. 1 min], [alle],
        [2.04], [M], [Gestenerkennung], [Erkennen der drei Handzeichen «Sitz», «Platz» und «Auf»], [I],
        [2.05], [M], [Sprachsteuerung], [Erkennen der vier Wörter «Hier», «Brav», «Sitz» und «Such» von Angesicht zu Angesicht auf 0.5–2 m Abstand], [I],
        [2.06], [M], [Interaktionsbereich], [Kreis mit r = 1.5 m], [alle],
        [2.07], [F], [Kunststück], [Roboter kann ein Kunststück ausführen], [alle],
        [2.08], [M], [Umgebungstemperatur], [Roboter funktioniert indoor bei Raumtemperatur von 10 °C bis 35 °C], [alle],
        [2.09], [M], [Umgebungslärm], [Akustischer Lärm im Wettbewerb wird gering gehalten], [Dozierende],
        [2.10], [M], [Belichtung], [Roboter funktioniert indoor bei Tageslicht], [alle],

        gruppe[3 Budget],
        [3.01], [M], [Gesamtbudget], [Für das gesamte Projekt stehen CHF 500.– zur Verfügung. In PREN1 dürfen davon maximal CHF 200.– ausgegeben werden, inklusive Kaufteile und Software.], [CFO],
        [3.02], [F], [Nicht kostenrelevante Mittel], [Private Laptops, Computer, Smartphones, Tablets sowie Netz- und Ladegeräte sind von der Kostenrechnung ausgenommen, sofern sie nicht eigens für das Projekt gekauft wurden.], [–],

        gruppe[4 Datenschutz, Nachhaltigkeit und gesellschaftliche Aspekte],
        [4.01], [F], [Datenschutz], [Konzept für die Nutzung von Kamera-, Audio- und weiteren Sensordaten sowie von KI], [I],
        [4.02], [F], [Datensicherheit], [Schutz vor unbeabsichtigtem Zugriff], [I],
        [4.03], [M], [Gesellschaftliche Aspekte], [Folgen eines interaktiven Roboters werden beachtet], [alle],
        [4.04], [M], [Verantwortungsvoller Umgang mit KI], [Risiken und Grenzen des KI-Einsatzes werden beachtet], [alle],

        gruppe[5 Material und Maschinennutzung],
        [5.01], [F], [Normteile], [Normteile (z. B. Schrauben, Widerstände) werden kostenlos aus der HSLU-Werkstatt bezogen], [M, Et],
        [5.02], [F], [Gesponserte Komponenten], [Gesponserte Komponenten dürfen verwendet werden. Sie werden zur Wahrung der Chancengleichheit zum Marktpreis in die Kostenrechnung einbezogen.], [alle],
        [5.03], [F], [Rapid Prototyping], [Bauteile können mit den 3D-Druckern der HSLU oder mit privaten Geräten gedruckt werden; die verarbeitete Menge muss ausgewiesen werden], [M, Et],
        [5.04], [M], [3D-Druck], [Maximal 25 h Maschinenlaufzeit am 3D-Drucker], [M, Et],
        [5.05], [M], [Lasergerät], [Maximal 1 h Maschinenlaufzeit am Lasergerät], [M],
        [5.06], [M], [Werkstattpersonal], [Maximal je 10 h Arbeitszeit des Werkstattpersonals Maschinentechnik und Elektrotechnik], [M, Et],

        gruppe[6 Simulation],
        [6.01], [M], [Visualisierung], [Prozessschritte, Befehlserkennung und Suche werden visualisiert], [I],
        [6.02], [M], [Hardware-Abstraktion], [Der Zustandsautomat läuft im Simulator und auf dem Roboter. Kamera, Mikrofon und Motoren sind über austauschbare Schnittstellen angebunden.], [I],
        [6.03], [M], [Log-Wiedergabe], [Aufgezeichnete Läufe des echten Roboters (Zustände, Erkennungen, Position) können im Simulator abgespielt und analysiert werden], [I],
        [6.04], [M], [Testszenarien], [Sprach- und Gestenbefehle sind auslösbar, die Knochenposition im Suchfeld ist frei einstellbar], [I],
      )
    },
    caption: [Anforderungsliste],
  ) <tab-anforderungen>
]

// Querformat, damit die Skizze möglichst gross dargestellt wird
#[
  #set page(flipped: true)

  = Aufgabenskizze <kap-aufgabenskizze>

  #align(center + horizon)[
    #figure(
      image("assets/Aufgabenskizze.png", height: 13cm),
      caption: [Aufgabenskizze],
    ) <fig-aufgabenskizze>
  ]
]

#include "chapters/technologierecherche.typ"

#include "chapters/risikoanalyse.typ"

#bibliography("../../library/quellen.bib", title: "Quellenverzeichnis", style: "ieee")
