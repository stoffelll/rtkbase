ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base-debian:latest
FROM ${BUILD_FROM}

# System vorbereiten und Repo klonen
RUN apt-get update && apt-get install -y git sudo bash python3 python3-pip \
    && git clone https://github.com/stoffelll/rtkbase.git /opt/rtkbase

WORKDIR /opt/rtkbase

# Wir suchen die Installationsdatei dynamisch und führen sie aus, 
# egal wo sie liegt (z.B. in tools/ oder installer/)
RUN find . -name "install.sh" -exec bash {} --all \;

# Unser Home Assistant Startskript kopieren
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]