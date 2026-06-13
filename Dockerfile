FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/home/hermes
ENV PATH=/home/hermes/.local/bin:/root/.local/bin:/usr/local/bin:/usr/bin:/bin

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    openssh-client \
    procps \
    sqlite3 \
    tzdata \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /home/hermes -s /bin/bash hermes

USER hermes
WORKDIR /home/hermes

RUN curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

COPY --chown=hermes:hermes entrypoint.sh /usr/local/bin/hermes-cloud-entrypoint.sh

USER root
RUN chmod +x /usr/local/bin/hermes-cloud-entrypoint.sh

USER hermes
WORKDIR /home/hermes

EXPOSE 8443

ENTRYPOINT ["/usr/local/bin/hermes-cloud-entrypoint.sh"]
