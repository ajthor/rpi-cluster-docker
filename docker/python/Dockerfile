FROM rpi-cluster/alpine

ENV LANG=en_US.UTF-8 \
    APP_DIR=/srv/app \
    HOME=/root \
    PROFILE=/root/.bash_profile \
    PYENV_ROOT=/root/.pyenv \
    PATH=/root/.pyenv/shims:/root/.pyenv/bin:$PATH

RUN apk add --no-cache \
    ca-certificates \
    git \
    g++ \
    gcc \
    glib-dev \
		gdbm-dev \
		libc-dev \
    linux-headers \
    grep \
    gnupg \
    tar \
    patch

RUN apk add --no-cache --virtual .build-deps \
    curl \
    bash \
    bzip2-dev \
    openssl \
    openssl-dev \
    readline-dev \
    sqlite-dev \
    pax-utils \
    build-base \
    make \
    gettext \
    sqlite-dev \
    zlib-dev \
    wget \
    llvm \
    ncurses-dev \
    ncurses5-libs \
		tcl-dev \
		tk \
		tk-dev \
		xz-dev \
		zlib-dev
# RUN apk add --no-cache \
#     curl \
#     ca-certificates \
#     bash \
#     git \
#     openssl-dev \
#     readline-dev \
#     bzip2-dev \
#     sqlite-dev \
#     ncurses-dev \
#     linux-headers \
#     build-base

		# autoconf \
    # build-base \
    # curl \
		# libevent-dev \
		# libffi-dev \
    # libpq \
    # libxml2-dev \
    # libxslt-dev \
    # linux-headers \
		# ncurses5-libs \
    # make \
    # patch \
    # openssl \
    # openssl-dev \
		# readline-dev \
		# sqlite-dev \
		# yaml-dev \
		# zlib-dev \
		# xz

RUN curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash \
    && pyenv update

RUN touch $PROFILE \
    && echo 'export PATH="/root/.pyenv/bin:$PATH"' >> $PROFILE \
    && echo 'eval "$(pyenv init -)"' >> $PROFILE \
    && echo 'eval "$(pyenv virtualenv-init -)"' >> $PROFILE

RUN pyenv install --verbose 3.5.2

RUN apk del .build-deps
