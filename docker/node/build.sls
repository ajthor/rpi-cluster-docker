# This file takes the image from docker-library and builds it specifically
# using our base alpine image.

{%- set version = salt['pillar.get']('docker:images:node:version', '7.8.0') -%}
{%- set tmpdir = '/tmp/docker/rpi-cluster/node' %}

include:
  - docker.alpine.build

# Modify the Dockerfile.
{{ tmpdir }}/Dockerfile:
  file.managed:
    - source: salt://docker/node/Dockerfile
    - makedirs: True
    - template: jinja
    - defaults:
      - version: {{ node_version }}

# Build the image.
rpi-cluster/node:{{ node_version }}:
  dockerng.image_present:
    - build: {{ tmpdir }}
    - require:
      - file: {{ tmpdir }}/Dockerfile

rpi-cluster/node:latest:
  dockerng.image_present:
    - build: {{ tmpdir }}
    - require:
      - file: {{ tmpdir }}/Dockerfile
