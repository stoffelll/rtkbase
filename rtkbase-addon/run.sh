#!/usr/bin/env bash
echo "===================================================="
echo "          RTKBASE DIAGNOSE & DEBUG SKRIPT           "
echo "===================================================="

cd /opt/rtkbase

echo -e "\n[1] AKTUELLES VERZEICHNIS & INHALT (/opt/rtkbase):"
pwd
ls -la

echo -e "\n[2] PYTHON UMGEBUNG & VERSION:"
python3 --version
which python3

echo -e "\n[3] INSTALLIERTE PYTHON PAKETE (pip):"
pip list 2>/dev/null || python3 -m pip list

echo -e "\n[4] SUCHE NACH PYTHON-DATEIEN IM REPO:"
find . -maxdepth 3 -name "*.py"

echo -e "\n[5] SUCHE NACH START- / SHELL-SKRIPTEN (*.sh):"
find . -maxdepth 3 -name "*.sh"

echo -e "\n[6] INHALT DES TOOLS-ORDNERS (falls vorhanden):"
if [ -d "tools" ]; then
    ls -la tools/
else
    echo "Kein 'tools'-Ordner gefunden."
fi

echo -e "\n[7] INHALT DES INSTALL-SKRIPTS (erster 50 Zeilen):"
if [ -f "tools/install.sh" ]; then
    head -n 50 tools/install.sh
elif [ -f "install.sh" ]; then
    head -n 50 install.sh
else
    echo "Keine install.sh gefunden."
fi

echo "===================================================="
echo " DIAGNOSE ABGESCHLOSSEN. Container bleibt zur "
echo " Ansicht für 10 Minuten im Standby..."
echo "===================================================="

# Container am Leben halten, damit du die Logs in Ruhe lesen kannst
sleep 600