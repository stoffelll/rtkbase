ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base-debian:latest
FROM ${BUILD_FROM}

# System vorbereiten und Repo klonen
RUN apt-get update && apt-get install -y git sudo bash \
    && git clone https://github.com/stoffelll/rtkbase.git /opt/rtkbase

WORKDIR /opt/rtkbase

# --- DEBUG BLOCK START ---
RUN echo "=== INHALT DES HAUPTVERZEICHNISSES ===" \
    && ls -la \
    && echo "=== SUCHE NACH INSTALL-DATEIEN ===" \
    && find . -name "*install*" -o -name "*.sh"
# --- DEBUG BLOCK ENDE ---

# Wir lassen den fehlerhaften Befehl absichtlich weg, 
# damit der Build durchläuft und uns die Debug-Ausgaben im Log zeigt.

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]