import os

path = "/opt/rtkbase/web_app/ServiceController.py"
with open(path, "r") as f:
    code = f.read()

mock = """
class DummySystemdObj:
    def __init__(self, unit_name=b"", *args, **kwargs):
        self.unit_name = unit_name.decode("utf-8", errors="ignore") if isinstance(unit_name, bytes) else str(unit_name)
        self._load_state()

    def _load_state(self):
        import json, os
        STATE_FILE = "/data/service_states.json"
        states = {}
        if os.path.exists(STATE_FILE):
            try:
                with open(STATE_FILE, "r") as f: states = json.load(f)
            except: pass
        default_state = True if "main" in self.unit_name.lower() else False
        is_active = states.get(self.unit_name, default_state)
        self._state = b"active" if is_active else b"inactive"
        self._sub = b"running" if is_active else b"dead"

    def _save_state(self, is_active):
        import json, os
        STATE_FILE = "/data/service_states.json"
        states = {}
        if os.path.exists(STATE_FILE):
            try:
                with open(STATE_FILE, "r") as f: states = json.load(f)
            except: pass
        states[self.unit_name] = is_active
        with open(STATE_FILE, "w") as f: json.dump(states, f)

    @property
    def ActiveState(self): return self._state
    @property
    def SubState(self): return self._sub

    def Start(self, *args, **kwargs):
        self._state, self._sub = b"active", b"running"
        self._save_state(True)
        
        if "main" in self.unit_name.lower():
            import subprocess, os
            pid_file = f"/tmp/{self.unit_name}.pid"
            self.Stop()
            
            # Verwende die exakt funktionierende Syntax für str2str
            cmd = "/usr/bin/str2str -in file:///tmp/ttyV0 -out tcpsvr://:2101"
            
            proc = subprocess.Popen(cmd, shell=True, executable="/bin/bash")
            with open(pid_file, "w") as f: f.write(str(proc.pid))
        return True

    def Stop(self, *args, **kwargs):
        self._state, self._sub = b"inactive", b"dead"
        self._save_state(False)
        import os, signal, subprocess
        pid_file = f"/tmp/{self.unit_name}.pid"
        if os.path.exists(pid_file):
            try:
                with open(pid_file, "r", encoding="utf-8") as f: pid = int(f.read().strip())
                os.kill(pid, signal.SIGTERM)
                subprocess.call(["pkill", "-P", str(pid)])
            except: pass
            finally: 
                try: os.remove(pid_file)
                except: pass
        return True

    def Restart(self, *args, **kwargs):
        self.Stop()
        return self.Start()

    def GetUnitFileState(self, *args, **kwargs): return b"enabled"
    @property
    def Unit(self): return self
    @property
    def Manager(self): return self
    @property
    def Service(self): return self
    @property
    def User(self): return b"root"
    @property
    def _interfaces(self): return set()

class Unit(DummySystemdObj): pass
class Manager(DummySystemdObj): pass
"""

code = code.replace("class ServiceController(object):", mock + "\nclass ServiceController(object):")
with open(path, "w") as f:
    f.write(code)