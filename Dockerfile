FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/home/hermes
ENV PATH=/home/hermes/.local/bin:/root/.local/bin:/usr/local/bin:/usr/bin:/bin
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    openssh-client \
    passwd \
    procps \
    python3 \
    python3-pip \
    python3-venv \
    sqlite3 \
    tzdata \
    unzip \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 10001 hermes \
    && useradd \
      --uid 10001 \
      --gid 10001 \
      --create-home \
      --home-dir /home/hermes \
      --shell /bin/bash \
      hermes

USER hermes
WORKDIR /home/hermes

RUN curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

USER root

COPY --chown=hermes:hermes entrypoint.sh /usr/local/bin/hermes-cloud-entrypoint.sh

RUN chmod +x /usr/local/bin/hermes-cloud-entrypoint.sh

USER hermes
WORKDIR /home/hermes

EXPOSE 8443

ENTRYPOINT ["/usr/local/bin/hermes-cloud-entrypoint.sh"]
