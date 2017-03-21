FROM armhf/ubuntu:xenial

# Install dependencies.
RUN apt-get update && apt-get install -qy \
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
