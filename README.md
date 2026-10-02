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

Jede Abgabe hat ihre eigene Version (Tags `<abgabe>/vX.Y.Z`, z. B.
`milestone_1/v1.2.0`). Ein in `main` gemergter PR erzeugt für jede Abgabe,
deren Ordner `docs/deliveries/<abgabe>/` er ändert, ein eigenes GitHub-Release
mit dem PDF. Änderungen nur an `docs/library/` lösen kein Release aus. Die
Version steht im Dateinamen und im Dokument. Das Label auf dem PR bestimmt den
Versionssprung (für alle geänderten Abgaben):

| Label           | Beispiel                      | Wofür                        |
|-----------------|-------------------------------|------------------------------|
| `release:major` | v1.4.2 → v2.0.0 (neu: v1.0.0) | Neue Meilenstein-Abgabe      |
| `release:minor` | v1.4.2 → v1.5.0               | Neue Kapitel / Inhalte       |
| *(kein Label)*  | v1.4.2 → v1.4.3               | Korrekturen                  |
| `release:skip`  | –                             | Kein Release                 |

Ein Release lässt sich auch von Hand auslösen: Actions → «Release deliveries»
→ *Run workflow* mit Abgabe und Versionssprung.

Bei jedem PR werden die PDFs als Vorschau gebaut und im PR verlinkt.
Die Links im Quellenverzeichnis werden wöchentlich geprüft; defekte Links
landen in einem Issue.
