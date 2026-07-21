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

# --- DER FINALE REGEX-PATCH (Garantiert fehlerfreie Einrückung) ---
RUN python3 -c 'import re; p="/opt/rtkbase/web_app/ServiceController.py"; c=open(p).read(); open(p, "w").write(re.sub(r"^([ \t]*)manager = Manager\(_autoload=True\)", lambda m: f"{m.group(1)}try:\n{m.group(1)}    manager = Manager(_autoload=True)\n{m.group(1)}except Exception:\n{m.group(1)}    manager = None", c, flags=re.MULTILINE))'

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]