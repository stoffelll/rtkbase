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

# 2. Alle von RTKBase benoetigten RTKLIB-Programme kompilieren und an dem
# von der Web-App erwarteten Ort installieren.
RUN git clone https://github.com/rtklibexplorer/RTKLIB.git /tmp/RTKLIB && \
    make --directory=/tmp/RTKLIB/app/consapp/str2str/gcc && \
    make --directory=/tmp/RTKLIB/app/consapp/rtkrcv/gcc && \
    make --directory=/tmp/RTKLIB/app/consapp/convbin/gcc && \
    install -m 0755 /tmp/RTKLIB/app/consapp/str2str/gcc/str2str /usr/local/bin/str2str && \
    install -m 0755 /tmp/RTKLIB/app/consapp/rtkrcv/gcc/rtkrcv /usr/local/bin/rtkrcv && \
    install -m 0755 /tmp/RTKLIB/app/consapp/convbin/gcc/convbin /usr/local/bin/convbin && \
    ln -s /usr/local/bin/str2str /usr/bin/str2str && \
    /usr/local/bin/str2str --version && \
    /usr/local/bin/rtkrcv --version && \
    /usr/local/bin/convbin --version && \
    rm -rf /tmp/RTKLIB
	
# 3. RTKBase-Repository klonen. Die Add-on-Version ist absichtlich Teil der
# Build-Schicht, damit Docker bei jedem Release den aktuellen Web-App-Quellcode
# abruft und keinen veralteten git-clone-Layer wiederverwendet.
ARG RTKBASE_SOURCE_VERSION=1.2.2
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
