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

# --- SAUBERER PYTHON-PATCH FÜR SYSTEMD / DBUS ---
RUN python3 -c '
path = "/opt/rtkbase/web_app/ServiceController.py"
with open(path, "r") as f:
    content = f.read()

old_code = "manager = Manager(_autoload=True)"
new_code = "try:\n    manager = Manager(_autoload=True)\nexcept:\n    manager = None"

if old_code in content:
    content = content.replace(old_code, new_code)
    with open(path, "w") as f:
        f.write(content)
    print("Patch erfolgreich angewendet!")
else:
    print("Zielcode nicht gefunden!")
'

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]