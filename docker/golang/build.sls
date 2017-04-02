# This file takes the image from docker-library and builds it specifically
# using our base alpine image.

{%- set version = salt['pillar.get']('docker:images:golang:version', '1.8') -%}
{%- set tmpdir = '/tmp/docker/rpi-cluster/golang' %}

# Add the Dockerfile from repo.
{{ tmpdir }}/Dockerfile:
  file.managed:
    - source: salt://docker/alpine/Dockerfile
    - makedirs: True
    - template: jinja
    - defaults:
      version: {{ version }}

# Build the image.
rpi-cluster/golang:{{ version }}:
  dockerng.image_present:
    - build: {{ tmpdir }}
    - require:
      - file: {{ tmpdir }}/Dockerfile

rpi-cluster/golang:latest:
  dockerng.image_present:
    - build: {{ tmpdir }}
    - require:
      - file: {{ tmpdir }}/Dockerfile
