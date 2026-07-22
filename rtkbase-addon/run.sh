#!/bin/bash
set -e

echo "Stelle Persistenz für RTKBase Einstellungen her..."

# 1. Haupt-Einstellungsdatei persistieren
if [ ! -f /data/settings.json ]; then
    echo "{}" > /data/settings.json
    [ -f /opt/rtkbase/settings.json ] && cp /opt/rtkbase/settings.json /data/settings.json
fi
rm -f /opt/rtkbase/settings.json
ln -s /data/settings.json /opt/rtkbase/settings.json

# 2. Conf-Ordner (für Koordinaten, Port-Settings) persistieren
if [ ! -d /data/conf ]; then
    mkdir -p /data/conf
    [ -d /opt/rtkbase/conf ] && cp -r /opt/rtkbase/conf/* /data/conf/ 2>/dev/null || true
fi
rm -rf /opt/rtkbase/conf
ln -s /data/conf /opt/rtkbase/conf

echo "Lese Home Assistant Add-on Konfiguration..."

# Lese die Werte sicher mit jq aus
VCP_ENABLED=$(jq --raw-output '.virtual_com_port_enabled // false' /data/options.json)
VCP_IP=$(jq --raw-output '.virtual_com_port_ip // ""' /data/options.json)
VCP_PORT=$(jq --raw-output '.virtual_com_port_port // 6638' /data/options.json)

if [ "$VCP_ENABLED" = "true" ] && [ -n "$VCP_IP" ]; then
    echo "Virtueller COM-Port aktiviert! Verbinde zu TCP $VCP_IP:$VCP_PORT -> /tmp/ttyV0"
    
    # Entferne alte Reste, falls der Container neu startet
    rm -f /tmp/ttyV0
    
    # Starte socat im Hintergrund
    socat pty,link=/tmp/ttyV0,raw,echo=0 tcp:${VCP_IP}:${VCP_PORT} &
    
    sleep 2
    if [ -e /tmp/ttyV0 ]; then
        echo "/tmp/ttyV0 erfolgreich erstellt."
    else
        echo "FEHLER: /tmp/ttyV0 konnte nicht erstellt werden."
    fi
else
    echo "Virtueller COM-Port ist deaktiviert oder IP fehlt."
fi

echo "Starte RTKBase Add-on Webserver..."
cd /opt/rtkbase/web_app
python3 server.py