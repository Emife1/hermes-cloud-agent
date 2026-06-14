#!/usr/bin/env python3
import json
import os
import sys
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

STARTED_AT = time.time()
PORT = int(os.environ.get("PORT", "10000"))
GATEWAY_PID_FILE = Path("/tmp/hermes-gateway.pid")


def process_alive(pid: int) -> bool:
    try:
        os.kill(pid, 0)
        return True
    except ProcessLookupError:
        return False
    except PermissionError:
        return True
    except Exception:
        return False


def pidfile_gateway_pid():
    try:
        raw = GATEWAY_PID_FILE.read_text(encoding="utf-8").strip()
        if not raw:
            return None
        pid = int(raw)
        if process_alive(pid):
            return pid
    except Exception:
        return None
    return None


def scan_gateway_pid():
    proc = Path("/proc")
    if not proc.exists():
        return None

    for entry in proc.iterdir():
        if not entry.name.isdigit():
            continue

        try:
            cmdline = (
                (entry / "cmdline")
                .read_bytes()
                .replace(b"\x00", b" ")
                .decode("utf-8", errors="ignore")
            )
        except Exception:
            continue

        lowered = cmdline.lower()
        if "hermes" in lowered and "gateway" in lowered:
            try:
                return int(entry.name)
            except ValueError:
                continue

    return None


def gateway_status():
    pid = pidfile_gateway_pid() or scan_gateway_pid()
    return {
        "running": bool(pid),
        "pid": pid,
    }


class Handler(BaseHTTPRequestHandler):
    server_version = "HermesHealth/1.0"

    def log_message(self, fmt, *args):
        sys.stderr.write(
            "%s - - [%s] %s\n"
            % (self.client_address[0], self.log_date_time_string(), fmt % args)
        )
        sys.stderr.flush()

    def send_json(self, status_code: int, payload: dict):
        body = json.dumps(payload, sort_keys=True).encode("utf-8")
        self.send_response(status_code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        gateway = gateway_status()
        base = {
            "service": "hermes-cloud-agent",
            "ok": True,
            "port": PORT,
            "uptime_seconds": round(time.time() - STARTED_AT, 3),
            "gateway": gateway,
        }

        if self.path in ("/", "/healthz"):
            self.send_json(200, base)
            return

        if self.path == "/statusz":
            self.send_json(200, base)
            return

        if self.path == "/readyz":
            ready = bool(gateway["running"])
            payload = dict(base)
            payload["ok"] = ready
            self.send_json(200 if ready else 503, payload)
            return

        self.send_json(404, {"ok": False, "error": "not_found", "path": self.path})


def main():
    address = ("0.0.0.0", PORT)
    httpd = ThreadingHTTPServer(address, Handler)
    print(f"Health server listening on 0.0.0.0:{PORT}", flush=True)
    httpd.serve_forever()


if __name__ == "__main__":
    main()
