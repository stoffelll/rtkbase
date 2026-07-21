ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base-debian:latest
FROM ${BUILD_FROM}

# System vorbereiten und Repo klonen
RUN apt-get update && apt-get install -y git sudo bash \
    && git clone https://github.com/stoffelll/rtkbase.git /opt/rtkbase

WORKDIR /opt/rtkbase/tools

# Wir rufen das Skript explizit mit bash auf, damit Linux nicht den Systembefehl nutzt
RUN bash ./install.sh --all

# Unser Home Assistant Startskript kopieren
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]