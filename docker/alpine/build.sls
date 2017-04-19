# This file builds a local alpine linux box from scratch.

{% set tag = salt['pillar.get']('docker:images:alpine:tag') %}

{% if not salt['pillar.get']('docker:use_external_images', false) %}
{% set image = salt['pillar.get']('docker:images:alpine:image') %}
{% set download_url = salt['pillar.get']('docker:images:alpine:download_url') %}

{% set tempdir = salt['cmd.run']('mktemp -d -t alpine.XXXXXX') %}

# Add the Dockerfile from repo.
{{ tempdir }}/Dockerfile:
  file.managed:
    - source: salt://docker/alpine/Dockerfile
    - makedirs: True

# Get the rootfs from the alpine distro.
rootfs:
  cmd.run:
    - name: curl -o rootfs.tar.gz -sL {{ download_url }}
    - cwd: {{ tempdir }}

# Build the image.
{% if tag is defined %}
{{ image }}:{{ tag }}:
  dockerng.image_present:
    - build: {{ tempdir }}
    - onchanges:
      - cmd: rootfs
      - file: {{ tempdir }}/Dockerfile
{% endif %}

{{ image }}:latest:
  dockerng.image_present:
    - build: {{ tempdir }}
    - onchanges:
      - cmd: rootfs
      - file: {{ tempdir }}/Dockerfile

{% else %}
{% set image = salt['pillar.get']('docker:images:alpine:ext_image') %}

{{ image }}:{{ tag }}:
  dockerng.image_present

{% endif %}
