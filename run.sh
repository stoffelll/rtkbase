#!/usr/bin/env bash
echo "Starte RTKBase Add-on..."

# Hier kommt der Befehl rein, der RTKBase normalerweise startet
# z.B.:
cd /opt/rtkbase
# ./start_service.sh (oder was auch immer das Repo zum Starten nutzt)

# Wichtig: Das Skript darf sich nicht beenden, solange der Service läuft!
# Ein einfacher Trick, falls der Service im Hintergrund startet:
tail -f /dev/null