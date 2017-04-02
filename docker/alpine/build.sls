# This file builds a local alpine linux box from scratch.

{%- set version = salt['pillar.get']('docker:images:base_image:version', '3.5.2') -%}
{%- set tmpdir = '/tmp/docker/rpi-cluster/alpine' %}

# Add the Dockerfile from repo.
{{ tmpdir }}/Dockerfile:
  file.managed:
    - source: salt://docker/alpine/Dockerfile
    - makedirs: True

# Get the rootfs from the alpine distro.
rootfs:
  cmd.run:
    - name: curl -o rootfs.tar.gz -sL  https://nl.alpinelinux.org/alpine/v3.5/releases/armhf/alpine-minirootfs-{{ version }}-armhf.tar.gz
    - cwd: {{ tmpdir }}

# Build the image.
rpi-cluster/alpine:{{ version }}:
  dockerng.image_present:
    - build: {{ tmpdir }}
    - require:
      - cmd: rootfs
      - file: {{ tmpdir }}/Dockerfile

rpi-cluster/alpine:latest:
  dockerng.image_present:
    - build: {{ tmpdir }}
    - require:
      - cmd: rootfs
      - file: {{ tmpdir }}/Dockerfile
