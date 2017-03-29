# This file builds a local alpine linux box from scratch.

# Create the temp directory.
/tmp/docker/alpine:
  file.directory:
    - makedirs: True

# Get the rootfs from the alpine distro.
rootfs:
  cmd.run:
    - name: curl -o rootfs.tar.gz -sL  https://nl.alpinelinux.org/alpine/v3.5/releases/armhf/alpine-minirootfs-3.5.2-armhf.tar.gz
    - cwd: /tmp/docker/alpine

# Add the Dockerfile from repo.
/tmp/docker/alpine/Dockerfile:
  file.managed:
    - source: salt://docker/alpine/Dockerfile

# Build the image.
rpi-cluster/alpine:3.5.2:
  dockerng.image_present:
    - build: /tmp/docker/alpine
    - require:
      - cmd: rootfs
      - file: /tmp/docker/alpine/Dockerfile

rpi-cluster/alpine:latest:
  dockerng.image_present:
    - build: /tmp/docker/alpine
    - require:
      - cmd: rootfs
      - file: /tmp/docker/alpine/Dockerfile
