#!/usr/bin/env bash
echo "Starte RTKBase Add-on Webserver..."

cd /opt/rtkbase/web_app

# Startet den RTKBase Webserver direkt im Vordergrund auf Port 80
# (Home Assistant leitet Port 80 intern auf deine 16080 nach außen um)
exec python3 server.py --port 80