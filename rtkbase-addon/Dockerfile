ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base-debian:latest
FROM ${BUILD_FROM}

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

RUN git clone https://github.com/stoffelll/rtkbase.git /opt/rtkbase

WORKDIR /opt/rtkbase

RUN if [ -f "web_app/requirements.txt" ]; then \
        pip3 install --no-cache-dir --ignore-installed urllib3 requests -r web_app/requirements.txt --break-system-packages; \
    fi

# --- PATCH FÜR SYSTEMD / DBUS ---
# Wir fangen den DBusFileNotFoundError in ServiceController.py ab, 
# damit der Webserver auch ohne echtes systemd im Container startet.
RUN sed -i 's/manager = Manager(_autoload=True)/try:\n\tmanager = Manager(_autoload=True)\nexcept:\n\tmanager = None/g' /opt/rtkbase/web_app/ServiceController.py

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]