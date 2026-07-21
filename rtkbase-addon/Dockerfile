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
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/stoffelll/rtkbase.git /opt/rtkbase

WORKDIR /opt/rtkbase

RUN if [ -f "web_app/requirements.txt" ]; then \
        pip3 install --no-cache-dir -r web_app/requirements.txt --break-system-packages && \
        pip3 install --no-cache-dir --upgrade "gevent>=23.9.1" greenlet urllib3 requests --break-system-packages; \
    fi

# --- UMFASSENDER SYSTEMD / DBUS MOCK (Final, mit _interfaces) ---
RUN echo 'path = "/opt/rtkbase/web_app/ServiceController.py"' > patch.py && \
    echo 'with open(path, "r") as f: code = f.read()' >> patch.py && \
    echo 'mock = """' >> patch.py && \
    echo 'class DummySystemdObj:' >> patch.py && \
    echo '    @property' >> patch.py && \
    echo '    def ActiveState(self): return b"inactive"' >> patch.py && \
    echo '    @property' >> patch.py && \
    echo '    def SubState(self): return b"dead"' >> patch.py && \
    echo '    def Start(self, *args, **kwargs): return True' >> patch.py && \
    echo '    def Stop(self, *args, **kwargs): return True' >> patch.py && \
    echo '    def Restart(self, *args, **kwargs): return True' >> patch.py && \
    echo '    def GetUnitFileState(self, *args, **kwargs): return b"disabled"' >> patch.py && \
    echo '    @property' >> patch.py && \
    echo '    def Unit(self): return self' >> patch.py && \
    echo '    @property' >> patch.py && \
    echo '    def Manager(self): return self' >> patch.py && \
    echo '    @property' >> patch.py && \
    echo '    def Service(self): return self' >> patch.py && \
    echo '    @property' >> patch.py && \
    echo '    def User(self): return b"root"' >> patch.py && \
    echo '    @property' >> patch.py && \
    echo '    def _interfaces(self): return set()' >> patch.py && \
    echo 'class Unit(DummySystemdObj):' >> patch.py && \
    echo '    def __init__(self, *args, **kwargs): pass' >> patch.py && \
    echo 'class Manager(DummySystemdObj):' >> patch.py && \
    echo '    def __init__(self, *args, **kwargs): pass' >> patch.py && \
    echo '"""' >> patch.py && \
    echo 'code = code.replace("class ServiceController(object):", mock + "class ServiceController(object):")' >> patch.py && \
    echo 'with open(path, "w") as f: f.write(code)' >> patch.py && \
    python3 patch.py && \
    rm patch.py

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]