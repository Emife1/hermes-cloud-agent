FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/home/hermes
ENV PATH=/home/hermes/.local/bin:/root/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN apt-get update && apt-get install -y --no-install-recommends bash ca-certificates curl git openssh-client passwd procps python3 python3-pip python3-venv sqlite3 tzdata unzip xz-utils && rm -rf /var/lib/apt/lists/*
RUN /usr/sbin/groupadd --gid 10001 hermes && /usr/sbin/useradd --uid 10001 --gid 10001 --create-home --home-dir /home/hermes --shell /bin/bash hermes
USER hermes
WORKDIR /home/hermes
RUN curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
RUN python3 - <<'PY'
import glob, os, subprocess, sys
patterns = ['/home/hermes/.local/**/bin/python','/home/hermes/**/bin/python']
candidates = [sys.executable]
for pattern in patterns:
    candidates.extend(glob.glob(pattern, recursive=True))
seen = []
for py in candidates:
    if py in seen or not os.path.exists(py):
        continue
    seen.append(py)
    try:
        print('installing telegram dependency into', py, flush=True)
        subprocess.run([py, '-m', 'pip', 'install', 'python-telegram-bot>=21,<22'], check=False, timeout=120)
    except Exception as exc:
        print('skipped', py, type(exc).__name__, flush=True)
print('telegram dependency install scan complete', len(seen), 'python interpreters checked', flush=True)
PY
USER root
COPY --chown=hermes:hermes render-config.yaml /usr/local/etc/hermes-render-config.yaml
COPY --chown=hermes:hermes entrypoint.sh /usr/local/bin/hermes-cloud-entrypoint.sh
COPY --chown=hermes:hermes health_server.py /usr/local/bin/hermes-health-server.py
RUN chmod +x /usr/local/bin/hermes-cloud-entrypoint.sh
USER hermes
WORKDIR /home/hermes
ENTRYPOINT ["/usr/local/bin/hermes-cloud-entrypoint.sh"]
