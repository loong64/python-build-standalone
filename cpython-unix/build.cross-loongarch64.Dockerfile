# Debian Trixie.
FROM debian@sha256:653dfb9f86c3782e8369d5f7d29bb8faba1f4bff9025db46e807fa4c22903671
MAINTAINER Gregory Szorc <gregory.szorc@gmail.com>

RUN groupadd -g 1000 build && \
    useradd -u 1000 -g 1000 -d /build -s /bin/bash -m build && \
    mkdir /tools && \
    chown -R build:build /build /tools

ENV HOME=/build \
    SHELL=/bin/bash \
    USER=build \
    LOGNAME=build \
    HOSTNAME=builder \
    DEBIAN_FRONTEND=noninteractive

CMD ["/bin/bash", "--login"]
WORKDIR '/build'

RUN for s in debian_trixie debian_trixie-updates; do \
      echo "deb http://snapshot.debian.org/archive/${s%_*}/20250515T202920Z/ ${s#*_} main"; \
    done > /etc/apt/sources.list && \
    for s in debian-security_trixie-security/updates; do \
      echo "deb http://snapshot.debian.org/archive/${s%_*}/20250515T175729Z/ ${s#*_} main"; \
    done >> /etc/apt/sources.list && \
    ( echo 'quiet "true";'; \
      echo 'APT::Get::Assume-Yes "true";'; \
      echo 'APT::Install-Recommends "false";'; \
      echo 'Acquire::Check-Valid-Until "false";'; \
      echo 'Acquire::Retries "5";'; \
    ) > /etc/apt/apt.conf.d/99cpython-portable && \
    rm -f /etc/apt/sources.list.d/*

# Host building.
RUN apt-get update && \
    apt-get install \
    bzip2 \
    ca-certificates \
    curl \
    debian-ports-archive-keyring \
    gcc \
    gcc-loongarch64-linux-gnu \
    g++ \
    libc6-dev \
    libc6-dev-loong64-cross \
    libcrypt-dev \
    libffi-dev \
    make \
    patch \
    perl \
    pkg-config \
    tar \
    xz-utils \
    unzip \
    zip \
    zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo "deb [arch=loong64] http://snapshot.debian.org/archive/debian-ports/20250515T194251Z/ sid main" >> /etc/apt/sources.list.d/debian-ports.list && \
    dpkg --add-architecture loong64 && \
    apt-get update && \
    apt-get install libcrypt-dev:loong64 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/*
