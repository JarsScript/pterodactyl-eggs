FROM node:21-bullseye-slim

LABEL author="JarsScript" maintainer="jarsscript@gmail.com"

RUN apt-get update 2>&1 \
  && apt-get -y install --no-install-recommends curl ffmpeg iproute2 git sqlite3 python3 tzdata ca-certificates dnsutils build-essential locales \
  && npm -g install npm@latest \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -m -d /home/container container \
  && locale-gen en_US.UTF-8

# RUN apk add --no-cache gcompat

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD [ "/bin/bash", "/entrypoint.sh" ]
