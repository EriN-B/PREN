# PREN – Team 03

Dokumentation (Typst) für PREN1 HS26 an der HSLU.

## Struktur

```
docs/
  deliveries/<abgabe>/doc.typ   Abgaben (z. B. milestone_1)
  library/template.typ          Vorlage
  library/quellen.bib           Quellenverzeichnis
  library/fonts/                Schriften (Inter)
scripts/build-deliveries.sh     Baut alle Abgaben als PDF
```

## Lokal bauen

Voraussetzung: [Typst](https://typst.app) 0.14 und `jq`.

```sh
scripts/build-deliveries.sh            # Entwurf (mit Wasserzeichen) nach dist/
```

In VS Code mit der Extension *Tinymist* funktioniert die Live-Vorschau direkt
(Einstellungen in `.vscode/settings.json`).

## Releases

Jeder in `main` gemergte PR erzeugt ein GitHub-Release mit allen Abgaben als
PDF. Die Version steht im Dateinamen und im Dokument. Das Label auf dem PR
bestimmt die Version:

| Label           | Beispiel          | Wofür                        |
|-----------------|-------------------|------------------------------|
| `release:major` | v1.4.2 → v2.0.0   | Neue Meilenstein-Abgabe      |
| `release:minor` | v1.4.2 → v1.5.0   | Neue Kapitel / Inhalte       |
| *(kein Label)*  | v1.4.2 → v1.4.3   | Korrekturen                  |
| `release:skip`  | –                 | Kein Release                 |

Bei jedem PR werden die PDFs als Vorschau gebaut und im PR verlinkt.
Die Links im Quellenverzeichnis werden wöchentlich geprüft; defekte Links
landen in einem Issue.
