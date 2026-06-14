#!/usr/bin/env python3
from http.server import BaseHTTPRequestHandler, HTTPServer
import json
import os
import signal
import time

STARTED_AT = time.time()
HOME = os.environ.get("HOME", "/home/hermes")
PID_FILE = os.environ.get("HERMES_GATEWAY_PID_FILE", os.path.join(HOME, ".hermes", "hermes-gateway.pid"))


def _read_gateway_pid():
    try:
        with open(PID_FILE, "r", encoding="utf-8") as handle:
            value = handle.read().strip()
        return int(value) if value else None
    except Exception:
        return None


def _pid_alive(pid):
    if not pid:
        return False
    try:
        os.kill(pid, 0)
        return True
    except ProcessLookupError:
        return False
    except PermissionError:
        return True
    except Exception:
        return False


def _status():
    pid = _read_gateway_pid()
    alive = _pid_alive(pid)
    return {
        "ok": True,
        "ready": alive,
        "service": "hermes-cloud-agent",
        "gateway_pid": pid,
        "gateway_alive": alive,
        "pid_file": PID_FILE,
        "uptime_seconds": round(time.time() - STARTED_AT, 2),
    }


class Handler(BaseHTTPRequestHandler):
    def _send_json(self, code, payload):
        data = json.dumps(payload, sort_keys=True).encode("utf-8")
        self.send_response(code)
        self.send_header("content-type", "application/json")
        self.send_header("content-length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self):
        status = _status()
        if self.path in ("/", "/healthz"):
            self._send_json(200, {"ok": True, "service": status["service"], "uptime_seconds": status["uptime_seconds"]})
            return
        if self.path == "/readyz":
            self._send_json(200 if status["ready"] else 503, status)
            return
        if self.path == "/statusz":
            self._send_json(200, status)
            return
        self._send_json(404, {"ok": False, "error": "not_found"})

    def log_message(self, fmt, *args):
        return


port = int(os.environ.get("PORT", "10000"))
print(f"Health server listening on 0.0.0.0:{port}", flush=True)
HTTPServer(("0.0.0.0", port), Handler).serve_forever()
