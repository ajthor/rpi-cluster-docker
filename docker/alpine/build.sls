# This file builds a local alpine linux box from scratch.

{% set version = salt['pillar.get']('docker:images:base_image:version') %}

{% if not salt['pillar.get']('docker:use_external_images', false) %}
{% set tag = salt['pillar.get']('docker:images:alpine:tag') %}
{% set rootfs_url = salt['pillar.get']('docker:images:alpine:rootfs_url') %}
{% set tmpdir = '/tmp/docker/rpi-cluster/alpine' %}

# Add the Dockerfile from repo.
{{ tmpdir }}/Dockerfile:
  file.managed:
    - source: salt://docker/alpine/Dockerfile
    - makedirs: True

# Get the rootfs from the alpine distro.
rootfs:
  cmd.run:
    - name: curl -o rootfs.tar.gz -sL {{ rootfs_url }}
    - cwd: {{ tmpdir }}

# Build the image.
{{ tag }}:{{ version }}:
  dockerng.image_present:
    - build: {{ tmpdir }}
    - onchanges:
      - cmd: rootfs
      - file: {{ tmpdir }}/Dockerfile

{{ tag }}:latest:
  dockerng.image_present:
    - build: {{ tmpdir }}
    - onchanges:
      - cmd: rootfs
      - file: {{ tmpdir }}/Dockerfile

{% else %}
{% set tag = salt['pillar.get']('docker:images:alpine:ext_tag') %}

{{ tag }}:{{ version }}:
  dockerng.image_present

{% endif %}
