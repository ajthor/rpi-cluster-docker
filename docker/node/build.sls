# This file takes the image from docker-library and builds it specifically
# using our base alpine image.

{% set version = salt['pillar.get']('docker:images:node:version', '7.8.0') %}

{% if not salt['pillar.get']('docker:use_external_images', false) %}
{% set tag = salt['pillar.get']('docker:images:node:tag') %}
{% set sha1 = salt['pillar.get']('docker:images:node:sha1') %}
{% set base_image = salt['pillar.get']('docker:images:base_image:tag') %}

{% set tmpdir = '/tmp/docker/rpi-cluster/node' %}

# Add the Dockerfile from repo.
{{ tmpdir }}/Dockerfile:
  file.managed:
    - source: salt://docker/node/Dockerfile
    - makedirs: True
    - template: jinja
    - defaults:
      version: {{ version }}
      base_image: {{ base_image }}
      sha1: {{ sha1 }}

# Build the image.
{{ tag }}:{{ version }}:
  dockerng.image_present:
    - build: {{ tmpdir }}
    - onchanges:
      - file: {{ tmpdir }}/Dockerfile

{{ tag }}:latest:
  dockerng.image_present:
    - build: {{ tmpdir }}
    - onchanges:
      - file: {{ tmpdir }}/Dockerfile

{% else %}
{% set tag = salt['pillar.get']('docker:images:node:ext_tag') %}

{{ tag }}:{{ version }}:
  dockerng.image_present

{% endif %}
