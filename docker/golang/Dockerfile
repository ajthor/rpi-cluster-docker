FROM {{ base }}

ENV GOLANG_VERSION {{ tag }}
ENV GOLANG_DOWNLOAD_URL {{ download_url }}
ENV GOLANG_SHA256 {{ sha256 }}

# Install dependencies
RUN apk add --no-cache \
    ca-certificates \
  && apk add --no-cache --virtual .build-deps \
    curl

RUN mkdir -p /usr/local/go \
	&& curl -SLO "$GOLANG_DOWNLOAD_URL" \
	&& echo "$GOLANG_SHA256  go$GOLANG_VERSION.linux-alpine-armhf.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GOLANG_VERSION.linux-alpine-armhf.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm -f go$GOLANG_VERSION.linux-alpine-armhf.tar.gz \
	&& apk del .build-deps

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/
