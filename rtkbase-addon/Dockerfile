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
    socat \
    jq \
    procps \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/stoffelll/rtkbase.git /opt/rtkbase

WORKDIR /opt/rtkbase

RUN if [ -f "web_app/requirements.txt" ]; then \
        pip3 install --no-cache-dir -r web_app/requirements.txt --break-system-packages && \
        pip3 install --no-cache-dir --upgrade "gevent>=23.9.1" greenlet urllib3 requests --break-system-packages; \
    fi

# Kopiere das saubere Python-Skript und patche den ServiceController
COPY patch.py /tmp/patch.py
RUN python3 /tmp/patch.py && rm /tmp/patch.py

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]