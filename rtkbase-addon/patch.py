import os

path = "/opt/rtkbase/web_app/ServiceController.py"
with open(path, "r") as f:
    code = f.read()

mock = """
class DummySystemdObj:
    def __init__(self, unit_name=b"", *args, **kwargs):
        self.unit_name = unit_name.decode("utf-8", errors="ignore") if isinstance(unit_name, bytes) else str(unit_name)
        self.Names = [self.unit_name.encode("utf-8")] if self.unit_name else []
        self.NRestarts = 0
        self.Result = b"success"
        self._load_state()

    def _load_state(self):
        import json, os
        STATE_FILE = "/data/service_states.json"
        states = {}
        if os.path.exists(STATE_FILE):
            try:
                with open(STATE_FILE, "r") as f: states = json.load(f)
            except: pass
        default_state = False
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
        import subprocess, os
        pid_file = f"/tmp/{self.unit_name}.pid"
        self.Stop()

        if self.unit_name == "str2str_tcp.service":
            host = os.environ.get("RTKBASE_TCP_HOST", "")
            port = os.environ.get("RTKBASE_TCP_PORT", "6638")
            if not host:
                raise RuntimeError("RTKBASE_TCP_HOST is not configured")
            cmd = [
                "/usr/bin/str2str",
                "-in", f"tcpcli://{host}:{port}",
                "-out", "tcpsvr://:5015",
                "-b", "1",
            ]
        else:
            service_outputs = {
                "str2str_ntrip_A.service": "out_caster_A",
                "str2str_ntrip_B.service": "out_caster_B",
                "str2str_ntrip_C.service": "out_caster_C",
                "str2str_ntrip_D.service": "out_caster_D",
                "str2str_local_ntrip_caster.service": "out_local_caster",
                "str2str_rtcm_svr.service": "out_rtcm_svr",
                "str2str_rtcm_client.service": "out_rtcm_client",
                "str2str_rtcm_udp_svr.service": "out_rtcm_udp_svr",
                "str2str_rtcm_serial.service": "out_rtcm_serial",
                "str2str_file.service": "out_file",
            }
            output = service_outputs.get(self.unit_name)
            if output is None:
                self._state, self._sub = b"active", b"running"
                self._save_state(True)
                return True
            cmd = ["/opt/rtkbase/run_cast.sh", "in_tcp", output]

        proc = subprocess.Popen(cmd, cwd="/opt/rtkbase")
        with open(pid_file, "w") as f:
            f.write(str(proc.pid))
        self._state, self._sub = b"active", b"running"
        self._save_state(True)
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
    def ResetFailedUnit(self, *args, **kwargs): return True
    def EnableUnitFiles(self, *args, **kwargs): return True
    def DisableUnitFiles(self, *args, **kwargs): return True
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
