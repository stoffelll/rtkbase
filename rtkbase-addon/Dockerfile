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

# --- SAUBERER MULTI-LINE PYTHON-PATCH ---
RUN python3 -c '
file_path = "/opt/rtkbase/web_app/ServiceController.py"
with open(file_path, "r") as f:
    lines = f.readlines()

new_lines = []
for line in lines:
    if "manager = Manager(_autoload=True)" in line:
        indent = line[:line.index("manager")]
        new_lines.append(indent + "try:\n")
        new_lines.append(indent + "    " + line.strip() + "\n")
        new_lines.append(indent + "except:\n")
        new_lines.append(indent + "    manager = None\n")
    else:
        new_lines.append(line)

with open(file_path, "w") as f:
    f.writelines(new_lines)
print("ServiceController.py erfolgreich mit exakter Einrückung gepatcht!")
'

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]