# Changelog

## [1.2.3] - 2026-07-22

### Fixed

- RTKRCV ohne zusammengesetzten Shell-Befehl und mit begrenztem Prompt-Timeout gestartet.
- Lock-Reihenfolge beim Einlesen der RTKRCV-Optionen korrigiert.
- Suche nach RTKRCV-Konfigurationsdateien plattformunabhaengig zusammengesetzt; die Liste ist nicht mehr faelschlich leer.
- Gunicorn-Timeout fuer die interaktive RTKRCV-Initialisierung auf 120 Sekunden angehoben.
- Bei einem RTKRCV-Prompt-Timeout wird die bisherige Prozessausgabe ins Add-on-Protokoll geschrieben.

## [1.2.2] - 2026-07-22

### Fixed

- Fehlendes `/usr/local/bin/rtkrcv` ergaenzt, das fuer Satellitenstatus und Koordinatenberechnung benoetigt wird.
- `convbin` fuer die Rohdaten-/RINEX-Konvertierung ergaenzt.
- `str2str` zusaetzlich am von RTKBase erwarteten Pfad `/usr/local/bin/str2str` installiert.
- Image-Build prueft alle drei RTKLIB-Programme vor Abschluss der Build-Schicht.

## [1.2.1] - 2026-07-22

### Fixed

- Docker-Build-Cache fuer den RTKBase-Quellcode versionsabhaengig gemacht.
- Verhindert, dass nach einem Add-on-Update eine alte Weboberflaeche mit weiterhin sichtbaren COM-Port-Pflichtfeldern ausgeliefert wird.

## [1.2.0] - 2026-07-22

### Added

- Auswahl zwischen `tcp` und `serial` als GNSS-Eingangsmodus.
- USB-UART-Unterstuetzung mit konfigurierbarem Geraetepfad und seriellen Parametern.
- Anzeige des aktiven Eingangsmodus und der Quelle in den RTKBase-Einstellungen.

### Changed

- Die Add-on-Konfiguration ist jetzt die zentrale Quelle fuer die Receiver-Verbindung.
- Im Home-Assistant-Add-on werden die nicht wirksamen RTKBase-COM-Port-Felder durch eine schreibgeschuetzte Verbindungsanzeige ersetzt.
- `uart` ist fuer die Durchreichung lokaler USB-Serial-Geraete aktiviert.

### Fixed

- Bestehende `virtual_com_port_*`-Optionen werden bei Upgrades weiterhin als TCP-Konfiguration uebernommen.
- Der veraltete persistierte Wert `ttyV0` wird im TCP-Modus automatisch entfernt.

## [1.1.0] - 2026-07-22

### Added

- Direkte TCP-Anbindung einer entfernten GNSS-Quelle ueber die Add-on-Optionen.
- Automatischer Start der GNSS-Rohdaten-Bridge beim Add-on-Start.
- Prozesssteuerung fuer abhaengige RTKBase-Ausgabedienste ohne systemd.

### Changed

- Unterstuetzte Add-on-Architektur auf Home Assistant OS `amd64` festgelegt.
- RTKBase-Konfiguration dauerhaft als `/data/settings.conf` gespeichert.
- Unnoetige virtuelle PTY- und `socat`-Zwischenschicht entfernt.

### Fixed

- Internen RTKBase-Rohdatenport von 2101 auf 5015 korrigiert; Port 2101 bleibt dem NTRIP-Caster vorbehalten.
- Erkennung und Steuerung von `str2str_tcp.service` repariert.
- Fehlende systemd-kompatible Methoden und Eigenschaften im Service-Controller ergaenzt.
- Doppelte und widerspruechliche Add-on-Metadaten entfernt.

## [1.0.0] - 2026-07-21

- Initiale Version des RTKBase-Add-ons.
- NTRIP-Caster-Port 2101 und HTTP-Port 16080 konfiguriert.
