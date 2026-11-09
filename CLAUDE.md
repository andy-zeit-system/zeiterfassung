# Zeiterfassung – Projektnotizen für Claude

Zeiterfassungs-App für PC und Handy (Ersatz für eine frühere Fremd-App). Sprache der App und der Kommunikation: **Deutsch**, einfache Erklärungen (Nutzer ist kein Entwickler).

## Aufbau
- `index.html` – die komplette App (HTML/CSS/JS in einer Datei, kein Build-Schritt). Läuft auf **GitHub Pages**: https://andy-zeit-system.github.io/zeiterfassung/ (Branch `main`, Ordner `/`). Nach `git push` ist sie nach 1–2 Minuten live.
- Datenbank: **Supabase** (Projekt-URL und öffentlicher *Publishable key* stehen oben im Script von `index.html`). Bibliothek `@supabase/supabase-js` per jsdelivr, feste Version.
- `supabase/schema.sql` – Tabellen `entries` und `settings`, Row Level Security: jede angemeldete Person sieht nur Zeilen mit ihrer `user_id`. Schema-Änderungen führt der Nutzer selbst im Supabase **SQL Editor** aus (Claude hat keinen Datenbank-Zugang außer über die App).
- Anmeldung: E-Mail + Passwort. Freie Registrierung ist in Supabase **abgeschaltet**; Konten legt der Nutzer im Supabase-Dashboard an (Authentication → Users → Add user).
- `manifest.webmanifest`, `icon*.png`, `icon.svg` – Installation als App auf dem Handy.

## Fachliche Regeln (nicht ohne Rückfrage ändern)
- Soll = `dailySoll` (4,98 Std.) je Arbeitstag (Mo–Sa), gezählt ab `startDate`.
- Urlaub/Krankheit zählen mit ihren Stunden (Standard = dailySoll) als Ist.
- Gesetzliche Feiertage Niedersachsen (Osterformel) werden **nur** an Arbeitstagen **ohne** Eintrag als bezahlte Stunden („Feiertagslohn“) gutgeschrieben.
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
