FROM alpine:3.9

ARG PEERTUBE_VER=v1.3.0-rc.1

WORKDIR /var/www/peertube
RUN adduser -h /var/www/peertube -s /bin/sh -D peertube && \
    chown peertube:peertube /var/www/peertube

RUN apk -U upgrade && \
    apk add ca-certificates ffmpeg nodejs nodejs-npm openssl yarn && \
    apk add -U vips-dev fftw-dev --repository http://dl-cdn.alpinelinux.org/alpine/edge/main/ --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ && \
    update-ca-certificates && \
    apk add --virt .dep curl git g++ python make unzip && \
    su peertube -c 'curl -sL "https://github.com/Chocobozzz/PeerTube/releases/download/$PEERTUBE_VER/peertube-$PEERTUBE_VER.zip" > peertube-$PEERTUBE_VER.zip && \
    unzip -q peertube-$PEERTUBE_VER.zip && \
    rm peertube-$PEERTUBE_VER.zip && \
    mv peertube-$PEERTUBE_VER/* . && \
    rmdir peertube-$PEERTUBE_VER && \
    yarn install --production --pure-lockfile && \
    yarn cache clean' && \
    apk del .dep && \
    rm -rf /tmp/* /var/cache/apk/*

USER peertube

ENV NODE_ENV=production
ENV NODE_CONFIG_DIR=/var/www/peertube/config
VOLUME [ "/storage" ]

CMD [ "/usr/bin/npm", "start" ]
