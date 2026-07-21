ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base-debian:latest
FROM ${BUILD_FROM}

# Grundlegende Systemwerkzeuge installieren
RUN apt-get update && apt-get install -y git sudo bash python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Repository klonen
RUN git clone https://github.com/stoffelll/rtkbase.git /opt/rtkbase

WORKDIR /opt/rtkbase

# Nur die Abhängigkeiten über das originale Setup-Skript installieren lassen
RUN ./tools/install.sh --dependencies

# Startskript kopieren
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]