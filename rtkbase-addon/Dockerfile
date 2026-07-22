ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base-debian:latest
FROM ${BUILD_FROM}

# 1. Alle benötigten System-Pakete und Build-Werkzeuge in einem Schritt installieren
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
    jq \
    procps \
    && rm -rf /var/lib/apt/lists/*

# 2. RTKLIB klonen und str2str für das System kompilieren
RUN git clone https://github.com/rtklibexplorer/RTKLIB.git /tmp/RTKLIB && \
    cd /tmp/RTKLIB/app/consapp/str2str/gcc && \
    make && \
    cp str2str /usr/bin/str2str && \
    chmod +x /usr/bin/str2str && \
    rm -rf /tmp/RTKLIB
	
# 3. RTKBase-Repository klonen. Die Add-on-Version ist absichtlich Teil der
# Build-Schicht, damit Docker bei jedem Release den aktuellen Web-App-Quellcode
# abruft und keinen veralteten git-clone-Layer wiederverwendet.
ARG RTKBASE_SOURCE_VERSION=1.2.1
RUN echo "Building RTKBase add-on ${RTKBASE_SOURCE_VERSION}" && \
    git clone --depth 1 --branch master https://github.com/stoffelll/rtkbase.git /opt/rtkbase

WORKDIR /opt/rtkbase

# 4. Python-Abhängigkeiten installieren
RUN if [ -f "web_app/requirements.txt" ]; then \
        pip3 install --no-cache-dir -r web_app/requirements.txt --break-system-packages && \
        pip3 install --no-cache-dir --upgrade "gevent>=23.9.1" greenlet urllib3 requests --break-system-packages; \
    fi

# 5. Patch anwenden
COPY patch.py /tmp/patch.py
RUN python3 /tmp/patch.py && rm /tmp/patch.py

# 6. Start-Skript einrichten
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
