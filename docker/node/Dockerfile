FROM rpi-cluster/alpine

RUN addgroup -g 1000 node \
    && adduser -u 1000 -G node -s /bin/sh -D node \
    apk add --no-cache \
      bash \
      libstdc++ \
    && apk add --update --no-cache --virtual .build-deps \
      bash \
      curl \
      g++ \
      gcc \
      gnupg \
      libgcc \
      linux-headers \
      make \

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash \
    && nvm install {{ node_version }} \
    && apk del .build-deps

CMD ["node"]
