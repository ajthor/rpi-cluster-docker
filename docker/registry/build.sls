# This file builds a local Registry image for ARM. It uses the official
# registry distribution repo as a base and makes some small replacements in the
# dockerfile to use the golang image specified in the pillar.

# For more reference, see:
# https://github.com/docker/distribution
# https://github.com/docker/distribution-library-image

{% set tag = salt['pillar.get']('docker:images:registry:tag') %}

{% if not salt['pillar.get']('docker:use_external_images', false) %}
{% set image = salt['pillar.get']('docker:images:registry:image') %}
{% set base = salt['pillar.get']('docker:images:base:image') %}

{% set tempdir = salt['cmd.run']('mktemp -d -t registry.XXXXXX') %}

# We need to copy the entrypoint file and the Dockerfile over to the temporary directory and build our new image.

# Copy files to temp dir.
{{ tempdir }}/Dockerfile:
  file.managed:
    - source: salt://docker/registry/Dockerfile
    - makedirs: True
    - template: jinja
    - defaults:
      base: {{ base }}

{{ tempdir }}/docker-entrypoint.sh:
  file.managed:
    - source: salt://docker/registry/docker-entrypoint.sh
    - makedirs: True
    - mode: 755

{% if tag is defined %}
{{ image }}:{{ tag }}:
  dockerng.image_present:
    - build: {{ tempdir }}
    - onchanges:
      - file: {{ tempdir }}/Dockerfile
      - file: {{ tempdir }}/docker-entrypoint.sh
{% endif %}

{{ image }}:latest:
  dockerng.image_present:
    - build: {{ tempdir }}
    - onchanges:
      - file: {{ tempdir }}/Dockerfile
      - file: {{ tempdir }}/docker-entrypoint.sh

{% else %}
{% set image = salt['pillar.get']('docker:images:registry:ext_image') %}

{{ image }}:{{ tag }}:
  dockerng.image_present

{% endif %}
