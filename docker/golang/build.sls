# This file takes the image from docker-library and builds it specifically
# using our base alpine image.

{% set version = salt['pillar.get']('docker:images:golang:version', '1.8') %}

{% if not salt['pillar.get']('docker:use_external_images', false) %}
{% set tag = salt['pillar.get']('docker:images:golang:tag') %}
{% set base_image = salt['pillar.get']('docker:images:base_image:tag') %}
{% set download_url = salt['pillar.get']('docker:images:golang:download_url') %}
{% set sha256 = salt['pillar.get']('docker:images:golang:sha256') %}

{% set tmpdir = '/tmp/docker/rpi-cluster/golang' %}

# Add the Dockerfile from repo.
{{ tmpdir }}/Dockerfile:
  file.managed:
    - source: salt://docker/golang/Dockerfile
    - makedirs: True
    - template: jinja
    - defaults:
      base_image: {{ base_image }}
      version: {{ version }}
      download_url: {{ download_url }}
      sha256: {{ sha256 }}

{{ tmpdir }}/go-wrapper:
  file.managed:
    - source: salt://docker/golang/go-wrapper
    - makedirs: True

# Build the image.
{{ tag }}:{{ version }}:
  dockerng.image_present:
    - build: {{ tmpdir }}
    - onchanges:
      - file: {{ tmpdir }}/Dockerfile
      - file: {{ tmpdir }}/go-wrapper

{{ tag }}:latest:
  dockerng.image_present:
    - build: {{ tmpdir }}
    - onchanges:
      - file: {{ tmpdir }}/Dockerfile
      - file: {{ tmpdir }}/go-wrapper

{% else %}
{% set tag = salt['pillar.get']('docker:images:golang:ext_tag') %}

{{ tag }}:{{ version }}:
  dockerng.image_present

{% endif %}
