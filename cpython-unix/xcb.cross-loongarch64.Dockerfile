{% include 'build.cross-loongarch64.Dockerfile' %}

RUN apt-get update && \
    apt-get install python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
