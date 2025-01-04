FROM debian:bullseye-slim

LABEL author="JarsScript" maintainer="jarsscript@gmail.com"

RUN dpkg --add-architecture i386 && apt-get update && apt-get -y install --no-install-recommends \
    wine32 \
    curl \
    wget \
    git \
    tmux \
    libsdl2-2.0-0 \
    libpulse0 \
    libcurl4-gnutls-dev \
    lib32gcc-s1 \
    lib32stdc++6 \
    locales \
    unzip && \
    apt-get clean

RUN useradd -m -d /home/container container

# Set the working directory and user
WORKDIR /home/container
USER container
ENV USER=container HOME=/home/container

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 25564/tcp 25564/udp

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]