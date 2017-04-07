FROM {{ base_image }}

ENV PYTHON_VERSION {{ version }}

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
	&& echo "{{ sha256 }}  Python-3.6.0.linux-alpine-armhf.tar.gz" | sha256sum -c - \
	&& tar -xzf "Python-$PYTHON_VERSION.linux-alpine-armhf.tar.gz" --strip-components=1 \
	&& rm "Python-$PYTHON_VERSION.linux-alpine-armhf.tar.gz" \
  # Set useful symlinks.
  && cd /usr/local/bin \
	&& ln -sf pip3 pip \
	&& ln -sf easy_install-3.6 easy_install \
	&& ln -sf idle3 idle \
	&& ln -sf pydoc3 pydoc \
	&& ln -sf python3 python \
	&& ln -sf python3-config python-config \
  # Update pip and setuptools.
  && pip install -U pip setuptools

CMD ["python"]
