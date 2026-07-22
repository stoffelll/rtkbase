#!/bin/bash
set -e

echo "Stelle Persistenz fuer RTKBase-Einstellungen her..."

# RTKBase liest und schreibt settings.conf, nicht settings.json.
if [ ! -f /data/settings.conf ]; then
    if [ -f /opt/rtkbase/settings.conf ]; then
        cp /opt/rtkbase/settings.conf /data/settings.conf
    else
        cp /opt/rtkbase/settings.conf.default /data/settings.conf
    fi
fi
rm -f /opt/rtkbase/settings.conf
ln -s /data/settings.conf /opt/rtkbase/settings.conf

echo "Lese Home Assistant Add-on Konfiguration..."

# Lese die Werte sicher mit jq aus
VCP_ENABLED=$(jq --raw-output '.virtual_com_port_enabled // false' /data/options.json)
VCP_IP=$(jq --raw-output '.virtual_com_port_ip // ""' /data/options.json)
VCP_PORT=$(jq --raw-output '.virtual_com_port_port // 6638' /data/options.json)

if [ "$VCP_ENABLED" = "true" ] && [ -n "$VCP_IP" ]; then
    export RTKBASE_TCP_HOST="$VCP_IP"
    export RTKBASE_TCP_PORT="$VCP_PORT"
    echo "TCP-GNSS-Quelle konfiguriert: $RTKBASE_TCP_HOST:$RTKBASE_TCP_PORT"
else
    echo "FEHLER: TCP-GNSS-Quelle ist deaktiviert oder die IP-Adresse fehlt."
    exit 1
fi

# Der Hauptdienst war auf einem normalen System per systemd beim Boot aktiv.
# Im Add-on starten wir ihn direkt und lassen die Weboberflaeche denselben PID
# anschliessend ueber den ServiceController verwalten.
echo "Starte GNSS-Rohdaten-Bridge auf internem TCP-Port 5015..."
/usr/bin/str2str \
    -in "tcpcli://${RTKBASE_TCP_HOST}:${RTKBASE_TCP_PORT}" \
    -out "tcpsvr://:5015" \
    -b 1 &
MAIN_PID=$!
echo "$MAIN_PID" > /tmp/str2str_tcp.service.pid
printf '{"str2str_tcp.service": true}\n' > /data/service_states.json

echo "Starte RTKBase Add-on Webserver..."
cd /opt/rtkbase/web_app
exec python3 server.py --port 80
