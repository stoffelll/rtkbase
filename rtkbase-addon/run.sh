#!/usr/bin/env bash
echo "Starte RTKBase Add-on..."

cd /opt/rtkbase

# Wir prüfen, ob es ein Startskript oder python-Hauptskript gibt und starten es direkt
if [ -f "server.py" ]; then
    echo "Starte server.py..."
    exec python3 server.py
elif [ -f "run.py" ]; then
    echo "Starte run.py..."
    exec python3 run.py
else
    # Fallback: Falls RTKBase über ein flask/gunicorn oder ein eigenes Skript läuft
    echo "Suche nach Startpunkten..."
    exec python3 -m flask run --host=0.0.0.0 --port=80
fi