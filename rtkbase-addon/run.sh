#!/usr/bin/env bash
echo "Starting RTKBase Add-on..."

cd /opt/rtkbase

# 1. GPSD starten (falls du einen lokalen GPS-Empfänger am ESP32/USB hast)
# (Passt den Device-Pfad an, z.B. /dev/ttyV0 das wir vorhin angelegt haben)
if [ -e /dev/ttyV0 ]; then
    echo "Starte gpsd auf /dev/ttyV0..."
    gpsd -F /var/run/gpsd.sock /dev/ttyV0
fi

# 2. RTKBase Webserver im Hintergrund starten
echo "Starte RTKBase Webserver..."
# (Der genaue Pfad zum Webserver-Skript, meist in einem Unterordner oder direkt startbar)
python3 -m rtkbase.web &

# 3. Den Webserver-Prozess im Vordergrund halten, damit der Container nicht stoppt
echo "RTKBase started"
wait