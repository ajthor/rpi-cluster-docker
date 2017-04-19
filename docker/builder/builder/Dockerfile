FROM rpi-cluster/alpine:3.5.2

# Install dependencies.
RUN apk add --update \
		ca-certificates \
		curl \
		openssl

# Install Docker.
RUN set -x \
  && curl -sSL https://get.docker.com/ -o /tmp/bootstrap.sh \
  && sh /tmp/bootstrap.sh \
  && rm /tmp/bootstrap.sh \
  && docker -v

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]
