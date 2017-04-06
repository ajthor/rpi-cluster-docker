FROM {{ base_image }}

ENV NODE_VERSION {{ version }}

# Install dependencies
RUN apk add --no-cache \
    curl \
    libgcc \
    libstdc++ \
    libuv \
    libcrypto1.0 \
    libssl1.0

RUN curl -SLO "http://resin-packages.s3.amazonaws.com/node/v$NODE_VERSION/node-v$NODE_VERSION-linux-alpine-armhf.tar.gz" \
  	&& echo "{{ sha1 }}  node-v$NODE_VERSION-linux-alpine-armhf.tar.gz" | sha256sum -c - \
  	&& tar -xzf "node-v$NODE_VERSION-linux-alpine-armhf.tar.gz" -C /usr/local --strip-components=1 \
  	&& rm "node-v$NODE_VERSION-linux-alpine-armhf.tar.gz" \
  	&& npm config set unsafe-perm true -g --unsafe-perm \
  	&& rm -rf /tmp/*

CMD ["node"]
