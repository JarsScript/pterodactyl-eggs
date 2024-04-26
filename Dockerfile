FROM node:21-bullseye-slim

LABEL author="JarsScript" maintainer="jarsscript@gmail.com"

RUN apk add --no-cache curl ffmpeg iproute2 git sqlite3 python3 tzdata ca-certificates dnsutils build-essential locales date libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev \
&& adduser -D -h /home/container container
# RUN apk add --no-cache gcompat

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD [ "/bin/bash", "/entrypoint.sh" ]
