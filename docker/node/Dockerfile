FROM {{ base }}

ENV NODE_VERSION {{ tag }}
ENV NODE_DOWNLOAD_URL {{ download_url }}
ENV NODE_SHA256 {{ sha256 }}

# Install dependencies
RUN apk add --no-cache \
    ca-certificates \
    libgcc \
    libstdc++ \
    libuv \
    libcrypto1.0 \
    libssl1.0 \
  && apk add --no-cache --virtual .build-deps \
    curl

RUN curl -SLO "$NODE_DOWNLOAD_URL" \
  	&& echo "$NODE_SHA256  node-v$NODE_VERSION-linux-alpine-armhf.tar.gz" | sha256sum -c - \
  	&& tar -xzf "node-v$NODE_VERSION-linux-alpine-armhf.tar.gz" -C /usr/local --strip-components=1 \
  	&& rm "node-v$NODE_VERSION-linux-alpine-armhf.tar.gz" \
  	&& npm config set unsafe-perm true -g --unsafe-perm \
  	&& rm -rf /tmp/* \
    && apk del .build-deps

CMD ["node"]
