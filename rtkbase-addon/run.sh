#!/bin/bash
set -e

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
    
    # Warte kurz, damit die virtuelle Schnittstelle erstellt wird
    sleep 2
    
    if [ -e /tmp/ttyV0 ]; then
        echo "/tmp/ttyV0 erfolgreich erstellt."
    else
        echo "FEHLER: /tmp/ttyV0 konnte nicht erstellt werden. socat fehlgeschlagen?"
    fi
else
    echo "Virtueller COM-Port ist deaktiviert oder IP fehlt."
fi

echo "Starte RTKBase Add-on Webserver..."
cd /opt/rtkbase/web_app
python3 server.py