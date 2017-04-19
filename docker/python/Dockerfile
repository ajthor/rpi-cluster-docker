FROM {{ base_image }}

ENV PYTHON_VERSION {{ version }}
ENV PYTHON_URL {{ download_url }}
ENV PYTHON_SHA256 {{ sha256 }}

RUN apk add --no-cache ca-certificates \
  && apk add --no-cache --virtual .build-deps \
    curl \
    libffi \
		libgcc \
    libstdc++ \
    libuv \
    libcrypto1.0 \
    libssl1.0

# Install Python.
RUN curl -SLO "$PYTHON_URL" \
	&& echo "$PYTHON_SHA256  Python-3.6.0.linux-alpine-armhf.tar.gz" | sha256sum -c - \
	&& tar -xzf "Python-$PYTHON_VERSION.linux-alpine-armhf.tar.gz" --strip-components=1 \
	&& rm "Python-$PYTHON_VERSION.linux-alpine-armhf.tar.gz"

# From https://nickjanetakis.com/blog/alpine-based-docker-images-make-a-difference-in-real-world-apps
#
# RUN apk add --no-cache --virtual .build-deps \
#   build-base postgresql-dev libffi-dev \
#     && pip install -r requirements.txt \
#     && find /usr/local \
#         \( -type d -a -name test -o -name tests \) \
#         -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
#         -exec rm -rf '{}' + \
#     && runDeps="$( \
#         scanelf --needed --nobanner --recursive /usr/local \
#                 | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
#                 | sort -u \
#                 | xargs -r apk info --installed \
#                 | sort -u \
#     )" \
#     && apk add --virtual .rundeps $runDeps \
#     && apk del .build-deps

# Set useful symlinks.
RUN cd /usr/local/bin \
	&& ln -sf pip3 pip \
	&& ln -sf easy_install-3.6 easy_install \
	&& ln -sf idle3 idle \
	&& ln -sf pydoc3 pydoc \
	&& ln -sf python3 python \
	&& ln -sf python3-config python-config

# Update pip and setuptools.
RUN pip install -U pip setuptools

CMD ["python"]
