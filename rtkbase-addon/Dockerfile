ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base-debian:latest
FROM ${BUILD_FROM}

# Systempakete installieren
RUN apt-get update && apt-get install -y git sudo bash python3 python3-pip python3-flask python3-requests \
    && rm -rf /var/lib/apt/lists/*

# Repository klonen
RUN git clone https://github.com/stoffelll/rtkbase.git /opt/rtkbase

WORKDIR /opt/rtkbase

# Startskript kopieren
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]