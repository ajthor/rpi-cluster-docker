# This file takes the image from docker-library and builds it specifically
# using our base alpine image.

{%- set version = salt['pillar.get']('docker:images:golang:version', '1.8') -%}
{%- set tmpdir = '/tmp/docker/rpi-cluster/golang' %}

# Add the Dockerfile from repo.
{{ tmpdir }}/Dockerfile:
  file.managed:
    - source: salt://docker/golang/Dockerfile
    - makedirs: True
    - template: jinja
    - defaults:
      version: {{ version }}

{{ tmpdir }}/go-wrapper:
  file.managed:
    - source: salt://docker/golang/go-wrapper
    - makedirs: True

# Build the image.
rpi-cluster/golang:{{ version }}:
  dockerng.image_present:
    - build: {{ tmpdir }}
    - require:
      - file: {{ tmpdir }}/Dockerfile
      - file: {{ tmpdir }}/go-wrapper

rpi-cluster/golang:latest:
  dockerng.image_present:
    - build: {{ tmpdir }}
    - require:
      - file: {{ tmpdir }}/Dockerfile
      - file: {{ tmpdir }}/go-wrapper
