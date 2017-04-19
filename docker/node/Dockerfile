FROM {{ base_image }}

ENV NODE_VERSION {{ version }}
ENV NODE_URL {{ download_url }}
ENV NODE_SHA256 {{ sha256 }}

# Install dependencies
RUN apk add --no-cache ca-certificates \
RUN apk add --no-cache --virtual .build-deps \
    curl \
    libgcc \
    libstdc++ \
    libuv \
    libcrypto1.0 \
    libssl1.0

RUN curl -SLO "$NODE_URL" \
  	&& echo "$NODE_SHA256  node-v$NODE_VERSION-linux-alpine-armhf.tar.gz" | sha256sum -c - \
  	&& tar -xzf "node-v$NODE_VERSION-linux-alpine-armhf.tar.gz" -C /usr/local --strip-components=1 \
  	&& rm "node-v$NODE_VERSION-linux-alpine-armhf.tar.gz" \
  	&& npm config set unsafe-perm true -g --unsafe-perm \
  	&& rm -rf /tmp/*

CMD ["node"]
