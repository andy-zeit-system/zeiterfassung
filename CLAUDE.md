# Zeiterfassung – Projektnotizen für Claude

Zeiterfassungs-App für PC und Handy (Ersatz für eine frühere Fremd-App). Sprache der App und der Kommunikation: **Deutsch**, einfache Erklärungen (Nutzer ist kein Entwickler).

## Aufbau
- `index.html` – die komplette App (HTML/CSS/JS in einer Datei, kein Build-Schritt). Läuft auf **GitHub Pages**: https://andy-zeit-system.github.io/zeiterfassung/ (Branch `main`, Ordner `/`). Nach `git push` ist sie nach 1–2 Minuten live.
- Datenbank: **Supabase** (Projekt-URL und öffentlicher *Publishable key* stehen oben im Script von `index.html`). Bibliothek `@supabase/supabase-js` per jsdelivr, feste Version.
- `supabase/schema.sql` – Tabellen `entries` und `settings`, Row Level Security: jede angemeldete Person sieht nur Zeilen mit ihrer `user_id`. Schema-Änderungen führt der Nutzer selbst im Supabase **SQL Editor** aus (Claude hat keinen Datenbank-Zugang außer über die App).
- Anmeldung: E-Mail + Passwort. Freie Registrierung ist in Supabase **abgeschaltet**; Konten legt der Nutzer im Supabase-Dashboard an (Authentication → Users → Add user).
- `manifest.webmanifest`, `icon*.png`, `icon.svg` – Installation als App auf dem Handy.

## Fachliche Regeln (nicht ohne Rückfrage ändern)
- Soll: Ist `monthlySoll` gesetzt (Vorgabe vom 11.11.2026: 130 Std. fest pro Monat, wie Excel und Firmennachweis), gilt dieser Wert für jeden Monat ab `startDate`. Sonst Soll = `dailySoll` je Arbeitstag (Mo–Sa), gezählt ab `startDate`.
- Rufbereitschaft (Vorgabe vom 11.11.2026): je Tag höchstens eine Art – übernommen 2,50 €, Rufbereitschaft 5 € (Sonn-/Feiertag 10 €), abgegeben 2,50 €. Gespeichert je Datum in den Einstellungen (`settings.rb`, kein eigenes Datenbankfeld), Sätze in `rbUeb`/`rbVoll`/`rbSoFei`/`rbAbg`. Nicht Teil des Bruttolohns.
- Überstunden-Auswertung: je Jahr ein Block; `overtimeCarry[Jahr]` setzt den Übertrag aus dem Vorjahr (2026: 290,55 aus Excel), `overtimePayout['JJJJ-MM']` sind ausbezahlte Überstunden und mindern den Saldo.
- Urlaub/Krankheit zählen mit ihren Stunden (Standard = dailySoll) als Ist.
- Gesetzliche Feiertage Niedersachsen (Osterformel) werden erkannt. Feiertage ohne Eintrag sind **freie Tage ohne Bezahlung** (Vorgabe vom 11.11.2026, Einstellung `holidayPaid` leer). Nur wenn `holidayPaid` gesetzt ist, werden sie an Arbeitstagen ohne Eintrag als „Feiertagslohn“ gutgeschrieben (alte ACHIM-Regel).
- Arbeitsstunden an Sonntagen und Feiertagen werden pro Monat für den Zuschlag zusammengezählt (`sfStd`, `sfTage` in `monthStats`).
- Stundenlohn hat einen Verlauf (`rates: [{from, rate}]`), gilt ab Datum.
- Lohnabrechnung: Zeitlohn, Urlaubslohn, Krankheitslohn, Feiertagslohn – ohne Zuschläge.
- Die Rechenlogik (`monthStats`) wurde für alle Monate gegen die alte App geprüft (Ist/Soll/Brutto stimmen). Bei Änderungen daran vorher/nachher vergleichen.

## Wichtig: Datenschutz
- Das Repository ist **öffentlich**. Niemals Arbeitsdaten, Namen, Beschreibungen, Backups (`*.json`, `*.csv`) oder E-Mail-Adressen committen. `.gitignore` sperrt die üblichen Datendateien – trotzdem vor jedem Commit `git status` prüfen.
- Echte Daten und Backups liegen nur lokal außerhalb des Repos (`D:\Zeiterfassung\`).
- Niemals den Supabase *Secret key* / *service_role* oder Passwörter in den Code oder Chat.
- Commits laufen unter `andy-zeit-system` mit noreply-Adresse.

## Arbeiten & Testen
- Lokale Vorschau: einfacher statischer Server auf diesen Ordner (z. B. Node-Einzeiler), dann im Browser öffnen.
- Ohne Login lassen sich die Ansichten mit **erfundenen** Testdaten prüfen: in der Konsole `USER`, `DB` setzen, `saveEntries`/`saveSettings`/`cacheSave` durch Dummies ersetzen, dann `shell(); render();`.
- Immer Handy-Breite (ca. 390 px) und PC prüfen, hell und dunkel.
- Nach Änderungen: committen und `git push` → GitHub Pages aktualisiert sich selbst.
