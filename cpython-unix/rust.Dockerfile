{% include 'base.Dockerfile' %}
RUN apt-get install \
    ca-certificates \
    curl \
    libc6-dev \
    python3 \
    tar \
