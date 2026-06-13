#!/usr/bin/env python3
from http.server import BaseHTTPRequestHandler, HTTPServer
import os
class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200 if self.path in ("/", "/healthz", "/readyz") else 404)
        self.end_headers()
        if self.path in ("/", "/healthz", "/readyz"):
            self.wfile.write(b"ok\n")
    def log_message(self, fmt, *args):
        return
port = int(os.environ.get("PORT", "10000"))
print(f"Health server listening on 0.0.0.0:{port}", flush=True)
HTTPServer(("0.0.0.0", port), Handler).serve_forever()
