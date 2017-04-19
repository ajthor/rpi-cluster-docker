# This file takes the image from docker-library and builds it specifically
# using our base alpine image.

{% set tag = salt['pillar.get']('docker:images:python:tag') %}

{% if not salt['pillar.get']('docker:use_external_images', false) %}

{% set image = salt['pillar.get']('docker:images:python:image') %}
{% set download_url = salt['pillar.get']('docker:images:python:download_url') %}
{% set sha256 = salt['pillar.get']('docker:images:python:sha256') %}

{% set base = salt['pillar.get']('docker:images:base:image') %}

{% set tempdir = salt['cmd.run']('mktemp -d -t python.XXXXXX') %}

# Add the Dockerfile from repo.
{{ tempdir }}/Dockerfile:
  file.managed:
    - source: salt://docker/python/Dockerfile
    - makedirs: True
    - template: jinja
    - defaults:
      base: {{ base }}
      tag: {{ tag }}
      download_url: {{ download_url }}
      sha256: {{ sha256 }}

# Build the image.
{% if tag is defined %}
{{ image }}:{{ tag }}:
  dockerng.image_present:
    - build: {{ tempdir }}
    - onchanges:
      - file: {{ tempdir }}/Dockerfile
{% endif %}

{{ image }}:latest:
  dockerng.image_present:
    - build: {{ tempdir }}
    - onchanges:
      - file: {{ tempdir }}/Dockerfile

{% else %}
{% set image = salt['pillar.get']('docker:images:python:ext_image') %}

{{ image }}:{{ tag }}:
  dockerng.image_present

{% endif %}
