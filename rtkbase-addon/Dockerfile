ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base-debian:latest
FROM ${BUILD_FROM}

# Abhängigkeiten installieren und das Repository klonen
RUN apt-get update && apt-get install -y git sudo bash \
    && git clone https://github.com/Stoffelll/rtkbase.git /opt/rtkbase

WORKDIR /opt/rtkbase

# Das Skript liegt im Unterordner tools/
RUN ./tools/install.sh --all

# Unser Home Assistant Startskript kopieren
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]