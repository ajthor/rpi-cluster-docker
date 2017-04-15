# This file builds a local Registry image for ARM. It uses the official
# registry distribution repo as a base and makes some small replacements in the
# dockerfile to use the golang image specified in the pillar.

# For more reference, see:
# https://github.com/docker/distribution
# https://github.com/docker/distribution-library-image

{% set base = salt['pillar.get']('docker:images:base:image') %}
{% set golang_image = salt['pillar.get']('docker:images:golang:image') %}
{% set golang_tag = salt['pillar.get']('docker:images:golang:tag') %}

{% if not salt['pillar.get']('docker:use_external_images', false) %}

{% set image = salt['pillar.get']('docker:images:registry:image', 'rpi-cluster/registry') %}
{% set tag = salt['pillar.get']('docker:images:registry:tag') %}

{% set tempdir = salt['cmd.run']('mktemp -d -t builder.XXXXXX') %}

# Copy files to {{ tempdir }}.
{{ tempdir }}/build.sh:
  file.managed:
    - source: salt://docker/registry/build.sh
    - template: jinja
    - defaults:
      image: {{ image }}
      tag: {{ tag }}
      tempdir: {{ tempdir }}

{{ tempdir }}/Dockerfile:
  file.managed:
    - source: salt://docker/registry/Dockerfile
    - template: jinja
    - defaults:
      base: {{ base }}
      tempdir: "{{ tempdir }}"

{{ tempdir }}/Dockerfile.build:
  file.managed:
    - source: salt://docker/registry/Dockerfile.build
    - template: jinja
    - defaults:
      base: {{ golang_image }}:{{ golang_tag }}

{{ tempdir }}/docker-entrypoint.sh:
  file.managed:
    - source: salt://docker/registry/docker-entrypoint.sh
    - mode: 755

salt://docker/registry/build.sh:
  cmd.script:
    - cwd: {{ tempdir }}
    - template: jinja
    - defaults:
      image: {{ image }}
      tag: {{ tag }}
      tempdir: {{ tempdir }}

{% else %}
{% set ext_image = salt['pillar.get']('docker:images:registry:ext_image') %}
{% set tag = salt['pillar.get']('docker:images:registry:tag') %}

{{ ext_image }}:{{ tag }}:
  dockerng.image_present

{% endif %}
