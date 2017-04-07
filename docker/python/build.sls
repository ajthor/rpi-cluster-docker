# This file takes the image from docker-library and builds it specifically
# using our base alpine image.

{% set version = salt['pillar.get']('docker:images:python:version', '3.6.0') %}

{% if not salt['pillar.get']('docker:use_external_images', false) %}
{% set tag = salt['pillar.get']('docker:images:python:tag') %}
{% set sha256 = salt['pillar.get']('docker:images:python:sha256') %}
{% set base_image = salt['pillar.get']('docker:images:base_image:tag') %}

{% set tmpdir = '/tmp/docker/rpi-cluster/python' %}

# Add the Dockerfile from repo.
{{ tmpdir }}/Dockerfile:
  file.managed:
    - source: salt://docker/python/Dockerfile
    - makedirs: True
    - template: jinja
    - defaults:
      version: {{ version }}
      base_image: {{ base_image }}
      sha256: {{ sha256 }}

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
{% set tag = salt['pillar.get']('docker:images:python:ext_tag') %}

{{ tag }}:{{ version }}:
  dockerng.image_present

{% endif %}
