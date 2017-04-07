FROM rpi-cluster/alpine

ENV PYTHON_VERSION=3.6.0 \
    PYTHON_PIP_VERSION=9.0.1

RUN apk add --no-cache \
    ca-certificates \
  && apk add --no-cache --virtual .build-deps \
    curl \
    libffi \
		libgcc \
    libstdc++ \
    libuv \
    libcrypto1.0 \
    libssl1.0

# Install Python.
RUN curl -SLO "http://resin-packages.s3.amazonaws.com/python/v$PYTHON_VERSION/Python-$PYTHON_VERSION.linux-alpine-armhf.tar.gz" \
	&& echo "01e9faafa87d5f5ca49d50971a4a1eead18982f9e2cd01880a3651a1bdbfc9f1  Python-3.6.0.linux-alpine-armhf.tar.gz" | sha256sum -c - \
	&& tar -xzf "Python-$PYTHON_VERSION.linux-alpine-armhf.tar.gz" --strip-components=1 \
	&& rm "Python-$PYTHON_VERSION.linux-alpine-armhf.tar.gz" \
  && pip install -U pip setuptools \
  && cd /usr/local/bin \
	&& ln -sf pip3 pip \
	&& ln -sf easy_install-3.6 easy_install \
	&& ln -sf idle3 idle \
	&& ln -sf pydoc3 pydoc \
	&& ln -sf python3 python \
	&& ln -sf python3-config python-config

CMD ["python"]
