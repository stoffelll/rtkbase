# Changelog

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
