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

# Neue Optionen; die virtual_com_port-Werte bleiben fuer Upgrades von <= 1.1
# als Rueckfall erhalten.
RECEIVER_CONNECTION=$(jq --raw-output '.receiver_connection // ""' /data/options.json)
LEGACY_VCP_ENABLED=$(jq --raw-output '.virtual_com_port_enabled // false' /data/options.json)
if [ -z "$RECEIVER_CONNECTION" ]; then
    if [ "$LEGACY_VCP_ENABLED" = "true" ]; then
        RECEIVER_CONNECTION="tcp"
    else
        RECEIVER_CONNECTION="serial"
    fi
fi

case "$RECEIVER_CONNECTION" in
    tcp)
        TCP_HOST=$(jq --raw-output 'if (.tcp_source_host // "") != "" then .tcp_source_host else (.virtual_com_port_ip // "") end' /data/options.json)
        TCP_PORT=$(jq --raw-output '.tcp_source_port // .virtual_com_port_port // 6638' /data/options.json)
        if [ -z "$TCP_HOST" ]; then
            echo "FEHLER: Im TCP-Modus muss tcp_source_host gesetzt sein."
            exit 1
        fi
        export RTKBASE_RECEIVER_CONNECTION="tcp"
        export RTKBASE_RECEIVER_SOURCE="${TCP_HOST}:${TCP_PORT}"
        export RTKBASE_INPUT_URI="tcpcli://${TCP_HOST}:${TCP_PORT}"
        # Entfernt nur den von Add-on-Version 1.0 erzeugten, nicht mehr
        # existierenden PTY-Namen. Echte serielle Einstellungen bleiben erhalten.
        sed -i "s/^com_port='ttyV0'$/com_port=''/" /data/settings.conf
        ;;
    serial)
        SERIAL_DEVICE=$(jq --raw-output '.serial_device // ""' /data/options.json)
        SERIAL_SETTINGS=$(jq --raw-output '.serial_settings // "115200:8:n:1"' /data/options.json)
        if [ -z "$SERIAL_DEVICE" ]; then
            echo "FEHLER: Im Serial-Modus muss serial_device gesetzt sein."
            exit 1
        fi
        case "$SERIAL_DEVICE" in
            /dev/*) ;;
            *) SERIAL_DEVICE="/dev/${SERIAL_DEVICE}" ;;
        esac
        if [ ! -e "$SERIAL_DEVICE" ]; then
            echo "FEHLER: Serielles Geraet $SERIAL_DEVICE ist im Add-on nicht vorhanden."
            exit 1
        fi
        export RTKBASE_RECEIVER_CONNECTION="serial"
        export RTKBASE_RECEIVER_SOURCE="$SERIAL_DEVICE"
        export RTKBASE_SERIAL_SETTINGS="$SERIAL_SETTINGS"
        export RTKBASE_INPUT_URI="serial://${SERIAL_DEVICE}:${SERIAL_SETTINGS}"
        ;;
    *)
        echo "FEHLER: receiver_connection muss tcp oder serial sein."
        exit 1
        ;;
esac

echo "GNSS-Eingang: $RTKBASE_RECEIVER_CONNECTION ($RTKBASE_RECEIVER_SOURCE)"

# Der Hauptdienst war auf einem normalen System per systemd beim Boot aktiv.
# Im Add-on starten wir ihn direkt und lassen die Weboberflaeche denselben PID
# anschliessend ueber den ServiceController verwalten.
echo "Starte GNSS-Rohdaten-Bridge auf internem TCP-Port 5015..."
/usr/bin/str2str \
    -in "$RTKBASE_INPUT_URI" \
    -out "tcpsvr://:5015" \
    -b 1 &
MAIN_PID=$!
echo "$MAIN_PID" > /tmp/str2str_tcp.service.pid
printf '{"str2str_tcp.service": true}\n' > /data/service_states.json

echo "Starte RTKBase Add-on Webserver..."
cd /opt/rtkbase/web_app
exec python3 server.py --port 80
