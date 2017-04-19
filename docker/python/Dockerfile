FROM {{ base }}

ENV PYTHON_VERSION {{ tag }}
ENV PYTHON_DOWNLOAD_URL {{ download_url }}
ENV PYTHON_SHA256 {{ sha256 }}

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
RUN curl -SLO "$PYTHON_DOWNLOAD_URL" \
	&& echo "$PYTHON_SHA256  Python-$PYTHON_VERSION.linux-alpine-armhf.tar.gz" | sha256sum -c - \
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
