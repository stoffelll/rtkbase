ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base-debian:latest
FROM ${BUILD_FROM}

# Abhängigkeiten installieren und das Repository klonen
RUN apt-get update && apt-get install -y git sudo bash \
    && git clone https://github.com/stoffelll/rtkbase.git /opt/rtkbase

# Wir wechseln in den tools-Ordner, in dem das install.sh liegt
WORKDIR /opt/rtkbase/tools

# Installationsskript ausführen
RUN ./install.sh --all

# Zurück ins Hauptverzeichnis wechseln und Startskript kopieren
WORKDIR /opt/rtkbase
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]