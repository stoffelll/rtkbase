ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base-debian:latest
FROM ${BUILD_FROM}

# Grundlegende Systemwerkzeuge, Build-Tools und systemd-Entwicklungsheader installieren
RUN apt-get update && apt-get install -y \
    git \
    sudo \
    bash \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    pkg-config \
    libsystemd-dev \
    python3-gevent \
    python3-flask \
    python3-requests \
    && rm -rf /var/lib/apt/lists/*

# Repository klonen
RUN git clone https://github.com/stoffelll/rtkbase.git /opt/rtkbase

WORKDIR /opt/rtkbase

# Requirements installieren (pkg-config und libsystemd-dev sind nun da, also baut auch pystemd sauber durch)
RUN if [ -f "web_app/requirements.txt" ]; then pip3 install --no-cache-dir -r web_app/requirements.txt --break-system-packages; fi

# Startskript kopieren
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]