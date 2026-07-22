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
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/stoffelll/rtkbase.git /opt/rtkbase

WORKDIR /opt/rtkbase

RUN if [ -f "web_app/requirements.txt" ]; then \
        pip3 install --no-cache-dir -r web_app/requirements.txt --break-system-packages && \
        pip3 install --no-cache-dir --upgrade "gevent>=23.9.1" greenlet urllib3 requests --break-system-packages; \
    fi

# --- UMFASSENDER SYSTEMD / DBUS MOCK (Stateful & Persistent) ---
RUN echo 'path = "/opt/rtkbase/web_app/ServiceController.py"' > patch.py && \
    echo 'with open(path, "r") as f: code = f.read()' >> patch.py && \
    echo 'mock = """' >> patch.py && \
    echo 'class DummySystemdObj:' >> patch.py && \
    echo '    def __init__(self, unit_name=b"", *args, **kwargs):' >> patch.py && \
    echo '        self.unit_name = unit_name.decode("utf-8", errors="ignore") if isinstance(unit_name, bytes) else str(unit_name)' >> patch.py && \
    echo '        self._load_state()' >> patch.py && \
    echo '    def _load_state(self):' >> patch.py && \
    echo '        import json, os' >> patch.py && \
    echo '        STATE_FILE = "/data/service_states.json"' >> patch.py && \
    echo '        states = {}' >> patch.py && \
    echo '        if os.path.exists(STATE_FILE):' >> patch.py && \
    echo '            try:' >> patch.py && \
    echo '                with open(STATE_FILE, "r") as f: states = json.load(f)' >> patch.py && \
    echo '            except: pass' >> patch.py && \
    echo '        default_state = True if "main" in self.unit_name.lower() else False' >> patch.py && \
    echo '        is_active = states.get(self.unit_name, default_state)' >> patch.py && \
    echo '        self._state = b"active" if is_active else b"inactive"' >> patch.py && \
    echo '        self._sub = b"running" if is_active else b"dead"' >> patch.py && \
    echo '    def _save_state(self, is_active):' >> patch.py && \
    echo '        import json, os' >> patch.py && \
    echo '        STATE_FILE = "/data/service_states.json"' >> patch.py && \
    echo '        states = {}' >> patch.py && \
    echo '        if os.path.exists(STATE_FILE):' >> patch.py && \
    echo '            try:' >> patch.py && \
    echo '                with open(STATE_FILE, "r") as f: states = json.load(f)' >> patch.py && \
    echo '            except: pass' >> patch.py && \
    echo '        states[self.unit_name] = is_active' >> patch.py && \
    echo '        with open(STATE_FILE, "w") as f: json.dump(states, f)' >> patch.py && \
    echo '    @property' >> patch.py && \
    echo '    def ActiveState(self): return self._state' >> patch.py && \
    echo '    @property' >> patch.py && \
    echo '    def SubState(self): return self._sub' >> patch.py && \
    echo '    def Start(self, *args, **kwargs):' >> patch.py && \
    echo '        self._state, self._sub = b"active", b"running"' >> patch.py && \
    echo '        self._save_state(True)' >> patch.py && \
    echo '        return True' >> patch.py && \
    echo '    def Stop(self, *args, **kwargs):' >> patch.py && \
    echo '        self._state, self._sub = b"inactive", b"dead"' >> patch.py && \
    echo '        self._save_state(False)' >> patch.py && \
    echo '        return True' >> patch.py && \
    echo '    def Restart(self, *args, **kwargs): return self.Start()' >> patch.py && \
    echo '    def GetUnitFileState(self, *args, **kwargs): return b"enabled"' >> patch.py && \
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
    echo 'class Unit(DummySystemdObj): pass' >> patch.py && \
    echo 'class Manager(DummySystemdObj): pass' >> patch.py && \
    echo '"""' >> patch.py && \
    echo 'code = code.replace("class ServiceController(object):", mock + "class ServiceController(object):")' >> patch.py && \
    echo 'with open(path, "w") as f: f.write(code)' >> patch.py && \
    python3 patch.py && \
    rm patch.py

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]