// ─────────────────────────────────────────────────────────────
//  Kapitel: Technologierecherche
//  Quelle: Projektunterlagen/Technologie Recherche.docx
//  Wird in «Meilenstein 1.typ» per #include eingebunden.
// ─────────────────────────────────────────────────────────────

// ── Hilfsfunktionen ──────────────────────────────────────────

// Bewertung (1–10) als farbiges Badge, none = nicht bewertet
#let bewertung(n) = {
  if n == none {
    text(fill: luma(150))[–]
  } else {
    let c = if n >= 8 { rgb("#15803d") } else if n >= 6 { rgb("#b45309") } else { rgb("#b91c1c") }
    box(
      fill: c.lighten(88%),
      stroke: 0.5pt + c.lighten(60%),
      inset: (x: 5pt, y: 3pt),
      radius: 3pt,
      text(fill: c, weight: "bold", size: 8.5pt, str(n)),
    )
  }
}

// Kompakte Pro/Contra-Liste
#let punkte(items, sym, farbe) = {
  if items.len() == 0 { return text(fill: luma(150))[–] }
  grid(
    columns: (0.8em, 1fr),
    row-gutter: 0.45em,
    ..items.map(i => (text(fill: farbe, weight: "bold", sym), i)).flatten()
  )
}

// Recherche-Verantwortliche unter dem Titel
#let recherche(..namen) = block(below: 1em)[
  #text(size: 9pt, fill: luma(110))[Recherche: #namen.pos().join(", ")]
]

// Technologietabelle
// Zeile: (name, quelle, beschreibung, pro: (..), contra: (..), note)
// Kurze Tabellen (≤ 3 Zeilen) bleiben zusammen, damit die Beschriftung nicht allein am Seitenende steht
#let tech-tabelle(caption, ..zeilen) = {
 show figure: set block(breakable: zeilen.pos().len() > 3)
 figure(
  kind: table,
  caption: caption,
  {
    set text(size: 8.5pt)
    set par(justify: false, leading: 0.5em)
    // Zeilen nicht über Seitenumbruch zerreissen
    set table.cell(breakable: false)
    table(
      columns: (2.9cm, 1fr, 1fr, 1fr, 1.65cm),
      align: (x, _) => if x == 4 { center + horizon } else { left + top },
      table.header([Variante], [Beschreibung], [Vorteile], [Nachteile], [Bewertung]),
      ..zeilen.pos().map(z => (
        [*#z.name* #if z.at("quelle", default: none) != none { linebreak(); z.quelle }],
        z.text,
        punkte(z.pro, "-", rgb("#000000")),
        punkte(z.contra, "-", rgb("#000000")),
        bewertung(z.note),
      )).flatten()
    )
  },
 )
}

// ─────────────────────────────────────────────────────────────

= Funktionszerlegung <kap-technologie>

Um für jede Teilfunktion des Hunde-Roboters eine fundierte Grundlage für die spätere Variantenauswahl zu schaffen, wurde das System in zwölf Funktionsbereiche gegliedert (@fig-funktionsbereiche). Für jeden Funktionsbereich hat das Team eine Technologierecherche durchgeführt und mögliche Lösungsvarianten mit Beschreibung, Vor- und Nachteilen sowie Quellen erfasst.

#figure(
  image("../assets/funktionsbereiche.png", width: 78%),
  caption: [Funktionsbereiche des Hunde-Roboters],
) <fig-funktionsbereiche>

= Technologierecherche

Jede Variante wurde anhand ihrer Eignung für das Projekt auf einer Skala von 1 bis 10 bewertet. Berücksichtigt wurden dabei insbesondere Umsetzungsaufwand, Kosten, Zuverlässigkeit und Nutzen im Hinblick auf die Aufgabenstellung @aufgabe. Varianten ohne Zahlenwert wurden qualitativ erfasst und noch nicht bewertet.

#align(center)[
  #set text(size: 8.5pt)
  #grid(
    columns: 4,
    column-gutter: 1.4em,
    align: horizon,
    [#bewertung(9) #h(0.2em) 8–10: gut geeignet],
    [#bewertung(6) #h(0.2em) 6–7: bedingt geeignet],
    [#bewertung(3) #h(0.2em) 1–5: wenig geeignet],
    [#bewertung(none) #h(0.2em) nicht bewertet],
  )
]

Die Bewertungen spiegeln den aktuellen Wissensstand nach der Recherche wider. Die definitive Auswahl der Varianten erfolgt erst im Rahmen der Konzeptbewertung.

// ─────────────────────────────────────────────────────────────
== Energieversorgung

#recherche[Eric Frick]


#tech-tabelle(
  [Technologievarianten Energieversorgung],
  (
    name: [LiFePO4-Akku], quelle: [@cmb-lipo-lifepo4 @delongtop-lipo],
    text: [Lithium-Eisenphosphat-Akku, Nennspannung 3.2 V pro Zelle],
    pro: ([Kaum Spannungseinbrüche unter Last], [Sehr sicher und langlebig], [Gut bei tiefen Temperaturen], [Kurze Ladezeiten]),
    contra: ([Höheres Gewicht], [Geringere Energiedichte], [Anfälliger für Beschädigung]),
    note: 7,
  ),
  (
    name: [LiPo-Akku], quelle: [@cmb-lipo-lifepo4 @delongtop-lipo],
    text: [Lithium-Polymer-Akku, Nennspannung 3.7 V pro Zelle],
    pro: ([Verschiedene Bauformen möglich], [Leicht], [Hohe Entladeströme (Einsatz in Drohnen)]),
    contra: ([Empfindlich auf Über- und Tiefentladung], [Kürzere Lebensdauer], [Spannung bricht unter Last schneller ein], [Enthält Cobalt (Umwelt)]),
    note: 8,
  ),
  (
    name: [Powerbank (USB-C, 5 V)],
    text: [Versorgung über eine handelsübliche Li-Ionen-Powerbank],
    pro: ([Plug-and-Play],),
    contra: ([Probleme bei Lastspitzen der Motoren], [Schaltet bei kleinen Strömen häufig ab]),
    note: 3,
  ),
  (
    name: [Powerbank + separater Akku für Aktoren],
    text: [Getrennte Versorgung von Steuerung und Aktoren/Sensoren],
    pro: ([Raspberry Pi (und ggf. Mikrocontroller) separat gespiesen → ausfallsicher], [Akku mit höherer Spannung für die Motoren]),
    contra: ([Höheres Gewicht und mehr Platzbedarf], [Zwei verschiedene Speisungen]),
    note: 8,
  ),
)

#pagebreak()
// ─────────────────────────────────────────────────────────────
== Rechenplattform

#recherche[Erin Bachmann, Cédric Gerber]


#tech-tabelle(
  [Technologievarianten Rechenplattform],
  (
    name: [Raspberry Pi 5 (4 GB)], quelle: [@reichelt-pi5],
    text: [Aktueller Einplatinencomputer],
    pro: ([4 GB RAM, ausreichend für KI-Anwendungen],),
    contra: ([Preis ca. CHF 120],),
    note: 8,
  ),
  (
    name: [NVIDIA Jetson Orin Nano], quelle: [@reichelt-jetson],
    text: [KI-Computer von NVIDIA],
    pro: ([Sehr hohe Rechenleistung],),
    contra: ([Für das Projektbudget deutlich zu teuer],),
    note: 1,
  ),
  (
    name: [Raspberry Pi 4 (4 GB)], quelle: [@reichelt-pi4],
    text: [Älteres Raspberry-Pi-Modell (2019)],
    pro: ([Etwas günstiger],),
    contra: ([Nicht für KI-Anwendungen ausgelegt],),
    note: 5,
  ),
)


// ─────────────────────────────────────────────────────────────
== Steuerungsarchitektur <kap-steuerung>

#recherche[Eric Frick, Samuel Felder]

#tech-tabelle(
  [Technologievarianten Steuerungsarchitektur],
  (
    name: [tinyK22], quelle: [@mcuoneclipse-tinyk22],
    text: [Mikrocontroller-Board der HSLU],
    pro: ([Bereits aus dem Modul MCFUN bekannt], [Zum halben Preis erhältlich, evtl. bereits im Besitz des Teams]),
    contra: ([Kein WLAN], [Wenige Beispiele im Internet], [Beschränkte Anzahl GPIOs]),
    note: 8,
  ),
  (
    name: [Raspberry Pi Pico], quelle: [@ekomp-pico],
    text: [Mikrocontroller-Board von Raspberry Pi],
    pro: ([Programmierbar mit MicroPython (einsteigerfreundlich)], [Sehr günstig], [Mehr RAM als tinyK22]),
    contra: ([WLAN nur bei der W-Variante],),
    note: 9,
  ),
  (
    name: [ESP32-S3], quelle: [@espressif-s3],
    text: [Leistungsfähiger Mikrocontroller, Einsatz ohne Raspberry Pi],
    pro: ([WLAN integriert], [Geeignet für Sprach- und Bildverarbeitung mit Kamera und KI]),
    contra: ([Gesamte Software in C zu programmieren],),
    note: 5,
  ),
  (
    name: [ESP32 (Classic/C-Serie)], quelle: [@prilchen-esp32 @openelab-vergleich],
    text: [Verbreiteter Mikrocontroller mit WLAN],
    pro: ([WLAN integriert], [Leistungsstark und zuverlässig], [Mehr RAM als tinyK22]),
    contra: ([Wenig stromsparend],),
    note: 8,
  )
)
#pagebreak()
// ─────────────────────────────────────────────────────────────
== Fortbewegung

#recherche[Lee Kürsener, Erin Bachmann, Samuel Felder, Jan Grisiger]

=== Fortbewegungskonzept

#tech-tabelle(
  [Technologievarianten Fortbewegungskonzept],
  (
    name: [Laufbeine], quelle: [@yt-roboterhund],
    text: [Fortbewegung ähnlich einem echten Hund; je nach Design drei oder mehr Aktoren pro Bein],
    pro: ([Vorlageprojekte online verfügbar], [Grosser Wow-Effekt]),
    contra: ([Komplizierte Ansteuerung], [Grosser Aufwand, vor allem beim Testen]),
    note: 6,
  ),
  (
    name: [Beine mit Rädern als Füsse],
    text: [Fahrender Hund: 1–2 Aktoren für die Gelenke und ein Radmotor pro Bein],
    pro: ([Einfachere Ansteuerung der Fortbewegung], [Eingesparter Aufwand der Laufsteuerung kann in Feinabstimmung fliessen]),
    contra: ([Geringere Hundeähnlichkeit], [Gelenkansteuerung für «Sitz», «Platz», «Auf» und Kunststück trotzdem nötig], [Verkabelung bis zum Fuss]),
    note: 8,
  ),
  (
    name: [Starre Beine mit Rädern],
    text: [Für «Sitz» und «Platz» werden die Beine als Ganzes nach vorne geklappt],
    pro: ([Kein Gelenk im Bein anzusteuern],),
    contra: ([Benötigt je nach Auslegung viel Kraft vom Motor],),
    note: 8,
  ),
  (
    name: [Panzersteuerung], quelle: [@wiki-tank],
    text: [Ein Elektromotor pro Seite; durch unterschiedliche Ansteuerung ist Wenden möglich],
    pro: ([Einfach umzusetzen],),
    contra: ([Wenig innovativ],),
    note: 8,
  ),
  (
    name: [Linearantrieb (Elektrozylinder)], quelle: [@conrad-zylinder],
    text: [Chassis wird angehoben bzw. abgesenkt, um «Sitz» und «Platz» einzunehmen],
    pro: ([Einfach elektrisch ansteuerbar],),
    contra: ([Eher teuer],),
    note: 8,
  ),
)

=== Antrieb

#tech-tabelle(
  [Technologievarianten Antrieb],
  (
    name: [Schrittmotor], quelle: [@ost-schrittmotor @brack-nema17 @igus-servo-stepper],
    text: [Antrieb der Beine bzw. Gelenke mit Schrittmotoren],
    pro: ([Genaue Ansteuerung], [Günstig], [Haltemoment ohne Stromverbrauch]),
    contra: ([Positionsverlust bei zu grosser Last], [Geringe Leistung bei hohen Drehzahlen]),
    note: 9,
  ),
  (
    name: [Servomotor], quelle: [@igus-servo-stepper @festo-servo],
    text: [Antrieb der Beine bzw. Gelenke mit Servomotoren],
    pro: ([Genaue Ansteuerung], [Stabile Drehzahlen]),
    contra: ([Teuer], [Komplexe Ansteuerung]),
    note: 7,
  ),
  (
    name: [DC-Getriebemotor + Encoder],
    text: [Antrieb der Räder; der Encoder erfasst die genaue Umdrehungszahl],
    pro: ([Genaue Steuerung einfach umsetzbar],),
    contra: ([Eher teuer],),
    note: 8,
  ),
)

#pagebreak()
// ─────────────────────────────────────────────────────────────
== Navigation <kap-navigation>

#recherche[Cédric Gerber, Erin Bachmann]


#tech-tabelle(
  [Technologievarianten Navigation],
  (
    name: [SLAM / V-SLAM],
    text: [Simultane Lokalisierung und Kartierung anhand von Umgebungsmerkmalen; bei V-SLAM über die Kamera],
    pro: ([Sehr flexibel gegenüber der Umgebung],),
    contra: ([Wahrscheinlich überdimensioniert], [Schwierig umsetzbar und rechenintensiv], [V-SLAM ist beleuchtungsempfindlich]),
    note: 5,
  ),
  (
    name: [Odometrie: Encoder + IMU],
    text: [Schätzung der aktuellen Position über die Strecke (Rad-Encoder) und den Winkel (IMU)],
    pro: ([Einfache und genügende Lösung],),
    contra: (),
    note: 9,
  ),
)


// ─────────────────────────────────────────────────────────────
== Simulator

#recherche[Cédric Gerber, Erin Bachmann]

=== Simulationsumgebung

#tech-tabelle(
  [Technologievarianten Simulationsumgebung],
  (
    name: [Eigenentwicklung], quelle: [@haber-pygame @lennartgr-pygame],
    text: [Eigene 2D-Draufsicht mit Spielfeld (Startfeld, Suchbereich, Hindernisse, Gegenstand) und Roboterkinematik],
    pro: ([Volle Kontrolle], [Sehr leichtgewichtig, schnell lauffähig], [Ideal als einfaches GUI gemäss Aufgabenstellung]),
    contra: ([Sensoren müssen selbst modelliert werden], [Keine echte Physik]),
    note: 10,
  ),
  (
    name: [IR-SIM], quelle: [@irsim],
    text: [Leichtgewichtiger 2D-Navigationssimulator in Python, Welt per YAML definiert],
    pro: ([Fertige Roboter- und Sensormodelle], [Per pip installierbar, schnelle Iteration]),
    contra: ([Keine Kamera-Simulation], [Weniger frei gestaltbar]),
    note: 8,
  ),
  (
    name: [Webots], quelle: [@webots-tutorial],
    text: [Open-Source-3D-Simulator mit Physik, Kamera, Distanzsensoren und Python-Controllern],
    pro: ([Objekterkennung mit echtem Bildverarbeitungscode testbar], [Gute Dokumentation], [Ohne ROS nutzbar]),
    contra: ([Einarbeitungsaufwand], [3D-Modell des Roboters nötig], [Eigene GUI-Elemente umständlich]),
    note: 8,
  ),
  (
    name: [CoppeliaSim (Edu)], quelle: [@coppelia-zmq],
    text: [3D-Simulator, Steuerung aus externem Python-Skript über ZeroMQ],
    pro: ([Gleiche Architektur wie auf dem echten Roboter], [Vision-Sensoren verfügbar]),
    contra: ([Edu-Lizenz nur für Lehre], [Gewöhnungsbedürftige Oberfläche]),
    note: 6,
  ),
  (
    name: [Gazebo + ROS 2], quelle: [@gazebo-ros],
    text: [Industriestandard-Simulator im ROS-Ökosystem],
    pro: ([Sehr realistisch], [Derselbe Code später auf dem Roboter]),
    contra: ([Hohe Einstiegshürde (Linux, URDF, ROS 2)], [Für den Zeitrahmen von PREN1 überdimensioniert]),
    note: 4,
  ),
  (
    name: [PyBullet], quelle: [@pybullet-quickstart],
    text: [Physik-Engine für Python mit Kamera-Rendering],
    pro: ([Reines Python, flexibel],),
    contra: ([Wenige fertige Welten für mobile Roboter], [Rudimentäre Visualisierung]),
    note: 4,
  ),
)

=== Ablauflogik und Visualisierung

#tech-tabelle(
  [Technologievarianten Ablauflogik und Visualisierung],
  (
    name: [python-statemachine], quelle: [@statemachine],
    text: [Deklarative Zustandsmaschine (z. B. Warten → Befehl erkannt → Quittieren → Suchen → Gefunden → Rückkehr)],
    pro: ([Zustandsdiagramm automatisch generierbar], [Aktueller Zustand im GUI darstellbar], [Gleicher Code für Simulator und Roboter]),
    contra: ([Für komplexe parallele Abläufe weniger geeignet],),
    note: 10,
  ),
  (
    name: [Behavior Trees (py_trees)], quelle: [@pytrees],
    text: [Modulare Alternative zur Zustandsmaschine],
    pro: ([Gut erweiterbar], [Standard in der Robotik]),
    contra: ([Mehr konzeptioneller Overhead], [Für wenige Befehle evtl. zu umfangreich]),
    note: 6,
  ),
  (
    name: [NiceGUI], quelle: [@nicegui],
    text: [Web-GUI in reinem Python (Buttons, Logs, Plots, Kamerabild)],
    pro: ([Läuft im Browser, auch vom Laptop aus], [Befehle per Button simulierbar]),
    contra: ([Asynchrone Programmierung erfordert Umdenken],),
    note: 8,
  ),
  (
    name: [Rerun], quelle: [@rerun],
    text: [Viewer für Kamerabilder, Hand-Landmarks, Posen und Zeitreihen mit Timeline],
    pro: ([Wenige Zeilen Code], [Testläufe abspielbar, dient als Testdokumentation]),
    contra: ([Nur Visualisierung, keine Bedienelemente],),
    note: 8,
  ),
)


// ─────────────────────────────────────────────────────────────
== Reaktion und Emotion

#recherche[Eric Frick, Jan Grisiger, Lee Kürsener]


=== Ausgabeelemente

#tech-tabelle(
  [Technologievarianten Ausgabeelemente],
  (
    name: [LED-Ringe / LED-Matrix], quelle: [@berrybase-ring @funduino-matrix],
    text: [Digital ansteuerbare RGB-LEDs (WS2812), angesteuert vom Mikrocontroller],
    pro: ([Einfach], [Günstig]),
    contra: ([Stromverbrauch könnte hoch sein],),
    note: 7,
  ),
  (
    name: [LED-Flächen / einzelne LEDs], quelle: [@conrad-flaechenled @bastelgarage-led @galaxus-leuchtmelder],
    text: [LED-Flächen, grosse LEDs oder Leuchtmelder als Augen],
    pro: ([Einfach und günstig], [Energiearm]),
    contra: ([Leuchtmelder nicht als RGB erhältlich],),
    note: 6,
  ),
  (
    name: [Lautsprecher], quelle: [@digikey-speaker],
    text: [Lautsprecher mit Verstärker, Signal vom Mikrocontroller],
    pro: ([Wirkt stärker wie eine Emotion], [Günstig]),
    contra: ([Verständlichkeit], [Zusätzlicher Audiotreiber nötig]),
    note: 7,
  ),
  (
    name: [Augen-Display],
    text: [OLED-Display zur Darstellung von Augen],
    pro: ([Ausdrucksstark],),
    contra: ([Höherer Programmieraufwand], [Gefahr von Overengineering]),
    note: 6,
  ),
)

=== Verhalten und Bewegung

#tech-tabelle(
  [Technologievarianten hundetypisches Verhalten],
  (
    name: [Im Kreis drehen], quelle: [@donaukurier-thi],
    text: [Der Roboter dreht sich vor Freude im Kreis, ähnlich wie ein echter Hund],
    pro: ([Authentisch], [Relativ einfache Umsetzung in Software]),
    contra: ([Drehen auf der Stelle muss möglich sein],),
    note: 7,
  ),
  (
    name: [Wedelnder Schwanz], quelle: [@techagekids-tail],
    text: [Der Roboter kann mit dem Schwanz wedeln],
    pro: ([Authentisch, hundetypisch], [Schwanz kann beim zweibeinigen Stand (Kunststück) als Stütze dienen]),
    contra: ([Zusätzlicher Motor/Servo nötig], [Zusätzliches Gewicht und mechanische Komplexität]),
    note: 6,
  ),
  (
    name: [Neigbarer Kopf],
    text: [Kopf kann geneigt werden, um einen fragenden Blick zu zeigen],
    pro: ([Erhöht die Hundeähnlichkeit],),
    contra: ([Erschwert unter Umständen die Navigation], [Zusätzlicher Antrieb und Gewicht]),
    note: 6,
  ),
  (
    name: [Revier markieren], quelle: [@yt-roboterhund],
    text: [Wasser wird aus einem Behälter über einen Schlauch abgegeben],
    pro: ([Humorvoller Effekt],),
    contra: ([Schwer und aufwändig], [Kein funktionaler Nutzen]),
    note: 7,
  ),
)


// ─────────────────────────────────────────────────────────────
== Audio-Erfassung

#recherche[Samuel Felder]


#tech-tabelle(
  [Technologievarianten Audio-Erfassung],
  (
    name: [Fertiges Spracher- \ kennungs-modul], quelle: [@mouser-sen0539],
    text: [Fertige Hardware für Raspberry Pi oder Mikrocontroller (z. B. DFRobot SEN0539). Bewertung gilt, sofern die Erkennung auf 1–2 m Abstand funktioniert.],
    pro: ([Potenziell kleinster Aufwand],),
    contra: ([Zuverlässigkeit der Module muss geprüft werden], [Höhere Kosten]),
    note: 7,
  ),
  (
    name: [Mikrofon + Schnittstelle],
    text: [Mikrofon über ein Modul (z. B. HAT) am Raspberry Pi oder über Verstärker und Filter direkt an einen ADC mit eigener Signalverarbeitung],
    pro: ([Geringste Kosten], [Volle Kontrolle über das Verhalten], [Flexible Platzierung der Mikrofone]),
    contra: ([Je nach Algorithmus hohe Hardwareanforderungen], [Mittlerer bis grosser Gesamtaufwand]),
    note: 8,
  ),
)


#pagebreak()
// ─────────────────────────────────────────────────────────────
== Objekterkennung

#recherche[Erin Bachmann, Cédric Gerber]


=== Sensorik

#tech-tabelle(
  [Technologievarianten Sensorik zur Objekterkennung],
  (
    name: [LiDAR], quelle: [@exptech-lidar],
    text: [Misst Entfernungen per Laser und erzeugt Distanzpunkte der Umgebung],
    pro: ([Unabhängig von sichtbarem Licht], [Gute Entfernungsmessung]),
    contra: ([Handerkennung schwierig], [Wenig detailliert]),
    note: 2,
  ),
  (
    name: [RGB-Kamera], quelle: [@rpi-cam3],
    text: [Normale Farbkamera, z. B. Raspberry Pi Camera Module 3],
    pro: ([Günstig], [Einfach]),
    contra: ([Abhängig von der Beleuchtung], [Keine Tiefeninformation], [Kamerawinkel müsste verstellbar sein]),
    note: 9,
  ),
  (
    name: [Tiefenkamera (Time-of-Flight)], quelle: [@arducam-tof],
    text: [Kamera, die zusätzlich die Tiefe bestimmen kann],
    pro: ([3D-Information], [Entfernung direkt bestimmbar]),
    contra: ([Aufwändig], [Höherer Rechen- und Energiebedarf], [Liefert teilweise keine normalen Bilder]),
    note: 6,
  ),
  (
    name: [KI-Kamera (Sony IMX500)], quelle: [@rpi-ai-cam],
    text: [RGB-Kamera mit integriertem KI-Beschleuniger auf dem Bildsensor, z. B. Raspberry Pi AI Camera],
    pro: ([Objekterkennung direkt auf der Kamera → entlastet den Raspberry Pi], [Liefert zusätzlich ein normales RGB-Bild (z. B. für MediaPipe)], [Offiziell von Ultralytics unterstützt]),
    contra: ([Nur Nano-Modelle (YOLOv8n/YOLO11n) offiziell exportierbar], [Aufwändige Modellkonvertierung (Quantisierung, RPK)], [Teurer als normale RGB-Kamera], [Keine Tiefeninformation]),
    note: 8,
  ),
  (
    name: [Synchronized Stereo Camera HAT for Raspberry Pi], quelle: [@pi-stereo-cam],
    text: [test],
    pro: (),
    contra: (),
    note: 9,
  )
)

=== Objekterkennung (Software)

#tech-tabelle(
  [Technologievarianten Objekterkennung],
  (
    name: [YOLO-World], quelle: [@ultralytics-yoloworld],
    text: [Open-Vocabulary-Objekterkennung],
    pro: ([Knochen und Personen ohne eigenes Training per Text-Prompt erkennbar], [Flexibel bei neuen Objekten], [Verschieden grosse Modelle]),
    contra: ([Mehr Rechenaufwand als YOLO26n], [Zero-Shot-Erkennung des Knochens muss getestet werden]),
    note: 8,
  ),
  (
    name: [YOLO26n], quelle: [@ultralytics-yolo26],
    text: [Sehr kleines YOLO26-Modell für schnelle Objekterkennung],
    pro: ([Sehr leichtgewichtig und schnell], [Gut geeignet für Raspberry Pi]),
    contra: ([Fine-Tuning für den Knochen nötig],),
    note: 9,
  ),
)

=== Gestenerkennung (Software)

#tech-tabelle(
  [Technologievarianten Gestenerkennung],
  (
    name: [MediaPipe Hand Landmarker], quelle: [@mediapipe],
    text: [Erkennt die Gelenkpunkte der Hand und liefert deren Koordinaten],
    pro: ([Relativ leichtgewichtig],),
    contra: ([Gestenlogik muss selbst implementiert werden], [Benötigt RGB-Bild]),
    note: 9,
  ),
  (
    name: [MobileCLIP2-S2], quelle: [@mobileclip],
    text: [Bildklassifikator, Klassen über Textbeschreibungen definierbar],
    pro: ([Kein spezifisches Gestenmodell nötig], [Neue Klassen per Textbeschreibung ergänzbar], [Universell einsetzbar]),
    contra: ([Nicht speziell für Handgesten entwickelt], [Deutlich höherer Rechenbedarf als Landmark-Erkennung], [Zuverlässigkeit bei ähnlichen Fingerstellungen zu testen]),
    note: 6,
  ),
)


// ─────────────────────────────────────────────────────────────
== Spracherkennung <kap-sprache>

#recherche[Cédric Gerber]


#tech-tabelle(
  [Technologievarianten Spracherkennung],
  (
    name: [OpenAI Whisper], quelle: [@whisper],
    text: [Allgemeine Spracherkennung (Speech-to-Text)],
    pro: ([Open Source], [Gute Erkennungsqualität], [Deutsch wird unterstützt]),
    contra: ([Vergleichsweise hoher Rechenaufwand], [Für wenige feste Befehle überdimensioniert]),
    note: 7,
  ),
  (
    name: [Whisper mit eingeschränktem Vokabular], quelle: [@whispercpp-command],
    text: [Speech-to-Text, beschränkt auf eine definierte Befehlsliste (whisper.cpp)],
    pro: ([Liefert nur verwertbare Transkriptionen],),
    contra: ([Zusätzliche Konfiguration nötig (unkritisch)],),
    note: 9,
  ),
  (
    name: [Picovoice Rhino], quelle: [@picovoice-rhino],
    text: [Ordnet Audio direkt einem Befehl (Intent) zu],
    pro: ([Geringer Rechenbedarf],),
    contra: ([Kostenloser Picovoice-Account und AccessKey nötig],),
    note: 8,
  ),
)


// ─────────────────────────────────────────────────────────────
== Kommunikationsschnittstellen <kap-kommunikation>

#recherche[Eric Frick, Samuel Felder]


#tech-tabelle(
  [Technologievarianten Kommunikationsschnittstellen],
  (
    name: [WLAN (MQTT)], quelle: [@rnt-esp32-mqtt @rnt-picow-mqtt],
    text: [Kommunikation zwischen Raspberry Pi und Mikrocontroller über das MQTT-Protokoll],
    pro: ([Keine Verkabelung], [Beliebig viele Mikrocontroller], [Keine Pinbelegung]),
    contra: ([Aufwändiger Code], [Datenschutz zu klären], [Nicht jeder Mikrocontroller hat WLAN], [Nicht echtzeitfähig und weniger zuverlässig]),
    note: 5,
  ),
  (
    name: [I²C], quelle: [@ew-i2c @gh-esp32-i2c @gh-rp2040-i2c],
    text: [Raspberry Pi als Master, Mikrocontroller als Slave],
    pro: ([Gute Codebeispiele], [Zuverlässig], [Nur 2 Leitungen, gemeinsamer Takt], [Mehrere Slaves möglich]),
    contra: ([Begrenzte Reichweite, störanfällig], [Langsamer als USB, nicht für Kamerastreams], [Softwareseitig aufwändig auf dem Mikrocontroller]),
    note: 7,
  ),
  (
    name: [UART], quelle: [@ew-uart @mcuoneclipse-ups @protonest-uart @penguintutor-pico @devto-pico-serial],
    text: [Serielle Punkt-zu-Punkt-Verbindung zwischen Raspberry Pi und Mikrocontroller],
    pro: ([Softwareseitig einfach umsetzbar], [Gute Codebeispiele (tinyK22, ESP32, Pico)], [Nur 2 Leitungen]),
    contra: ([Langsamer als USB, nicht für Kamerastreams], [Nur ein Mikrocontroller anschliessbar], [Baudrate muss übereinstimmen]),
    note: 9,
  ),
  (
    name: [SPI], quelle: [@sparkfun-spi],
    text: [Synchrone serielle Verbindung zwischen Raspberry Pi und Mikrocontroller],
    pro: ([Schnell], [Energiesparend (keine Pull-ups)]),
    contra: ([4 Leitungen, mehr Pins], [Zusätzliche Chip-Select-Leitung pro Mikrocontroller], [Für Kommunikation auf derselben Platine gedacht], [Keine Fehlerkorrektur im Protokoll]),
    note: 3,
  ),
)


// ─────────────────────────────────────────────────────────────
== Material und Design

#recherche[Jan Grisiger, Lee Kürsener]


=== Design

#tech-tabelle(
  [Designvarianten],
  (
    name: [Hundeähnlicher Aufbau], quelle: [@bostondynamics],
    text: [Aufbau mit Beinen und quaderförmigem Körper],
    pro: ([Steuerung und Komponenten einfach im Körper verbaubar],),
    contra: ([Beine eher komplex],),
    note: none,
  ),
  (
    name: [Realistisches Hundedesign], quelle: [@yt-hundedesign],
    text: [Sieht einem echten Hund sehr ähnlich],
    pro: ([Ansprechende Optik],),
    contra: ([Formen schwierig herzustellen],),
    note: none,
  ),
  (
    name: [Panzerdesign],
    text: [Bewegung ähnlich einem Panzer (Kettenantrieb)],
    pro: ([Relativ einfach umzusetzen],),
    contra: ([Ohne Beine nur bedingte Hundeähnlichkeit],),
    note: none,
  ),
)

=== Material

#tech-tabelle(
  [Materialvarianten],
  (
    name: [ABS], quelle: [@markforged-materialien],
    text: [Thermoplastischer Kunststoff für den 3D-Druck],
    pro: ([Günstig], [Ausgeglichene Werkstoffeigenschaften], [Gut 3D-druckbar]),
    contra: ([Schlechte chemische Beständigkeit], [Mittelmässige Festigkeit]),
    note: 9,
  ),
  (
    name: [PLA], quelle: [@markforged-materialien],
    text: [Biobasierter Kunststoff für den 3D-Druck],
    pro: ([Günstig], [Hohe Festigkeit und Steifigkeit], [Gut 3D-druckbar]),
    contra: ([Geringe Wärmebeständigkeit], [Geringe Haltbarkeit], [Schlechte chemische Beständigkeit]),
    note: none,
  ),
)


#pagebreak()
// ─────────────────────────────────────────────────────────────
== Zusammenfassung

@tab-tech-zusammenfassung fasst die jeweils am besten bewerteten Varianten pro Funktionsbereich zusammen. Sie bilden die Ausgangslage für die weitere Konzeptentwicklung.

#figure(
  {
    set text(size: 9pt)
    set par(justify: false)
    table(
      columns: (auto, 1fr, auto),
      align: (x, _) => if x == 2 { center + horizon } else { left + horizon },
      table.header([Funktionsbereich], [Höchstbewertete Variante(n)], [Bewertung]),
      [Energieversorgung], [LiPo-Akku; Powerbank + separater Akku für Aktoren], bewertung(8),
      [Rechenplattform], [Raspberry Pi 5 (4 GB)], bewertung(8),
      [Steuerungsarchitektur], [Raspberry Pi Pico (als Slave zum Raspberry Pi)], bewertung(9),
      [Fortbewegung], [Beine mit Rädern als Füsse], bewertung(8),
      [Antrieb], [Schrittmotor (Gelenke); DC-Getriebemotor + Encoder (Räder)], [#bewertung(9) #bewertung(8)],
      [Navigation], [Odometrie: Encoder + IMU (qualitativ favorisiert)], bewertung(none),
      [Simulator], [Pygame 2D; python-statemachine], bewertung(10),
      [Reaktion und Emotion], [Lautsprecher; Augen-Display; im Kreis drehen], bewertung(7),
      [Audio-Erfassung], [Fertiges Spracherkennungsmodul], bewertung(9),
      [Objekterkennung], [RGB-Kamera; YOLO26n; MediaPipe Hand Landmarker], bewertung(9),
      [Spracherkennung], [Whisper mit eingeschränktem Vokabular], bewertung(9),
      [Kommunikation], [UART], bewertung(9),
      [Material und Design], [ABS (Design noch offen)], bewertung(9),
    )
  },
  caption: [Höchstbewertete Varianten pro Funktionsbereich],
) <tab-tech-zusammenfassung>
