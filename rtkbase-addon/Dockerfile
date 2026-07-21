# Wir nutzen das Debian-basierte Image von Home Assistant
ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base-debian:latest
FROM ${BUILD_FROM}

# Abhängigkeiten installieren und das Repo (deinen Fork) klonen
RUN apt-get update && apt-get install -y git sudo bash \
    && git clone https://github.com/Stoffelll/rtkbase.git /opt/rtkbase

WORKDIR /opt/rtkbase

# Hier rufen wir das offizielle Install-Skript auf (ohne systemd-Dienste zu starten!)
RUN ./install.sh --all

# Unser Home Assistant Startskript kopieren
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]