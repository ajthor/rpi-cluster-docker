FROM rpi-cluster/alpine

ENV NODE_VERSION 7.7.3

# Install dependencies
RUN apk add --no-cache \
    curl \
    libgcc \
    libstdc++ \
    libuv \
    libcrypto1.0 \
    libssl1.0

RUN curl -SLO "http://resin-packages.s3.amazonaws.com/node/v$NODE_VERSION/node-v$NODE_VERSION-linux-alpine-armhf.tar.gz" \
  	&& echo "498357b1094b15943161ff591482f65b82e0a6b1eee9667cbf94996d64af340b  node-v7.7.3-linux-alpine-armhf.tar.gz" | sha256sum -c - \
  	&& tar -xzf "node-v$NODE_VERSION-linux-alpine-armhf.tar.gz" -C /usr/local --strip-components=1 \
  	&& rm "node-v$NODE_VERSION-linux-alpine-armhf.tar.gz" \
  	&& npm config set unsafe-perm true -g --unsafe-perm \
  	&& rm -rf /tmp/*

CMD ["node"]
