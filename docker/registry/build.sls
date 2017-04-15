# This file builds a local Registry image for ARM. It uses the official
# registry distribution repo as a base and makes some small replacements in the
# dockerfile to use the golang image specified in the pillar.

# For more reference, see:
# https://github.com/docker/distribution
# https://github.com/docker/distribution-library-image

{% set base = salt['pillar.get']('docker:images:base:name') %}
{% set golang_name = salt['pillar.get']('docker:images:golang:name') %}
{% set golang_tag = salt['pillar.get']('docker:images:golang:tag') %}

{% if not salt['pillar.get']('docker:use_external_images', false) %}

{% set name = salt['pillar.get']('docker:images:registry:name', 'rpi-cluster/registry') %}
{% set tag = salt['pillar.get']('docker:images:registry:tag') %}

{% set tempdir = salt['cmd.run']('mktemp -d -t builder.XXXXXX') %}

# Copy files to {{ tempdir }}.
{{ tempdir }}/Dockerfile:
  file.managed:
    - source: salt://docker/registry/Dockerfile
    - template: jinja
    - defaults:
      base: {{ base }}
      tempdir: {{ tempdir }}

{{ tempdir }}/Dockerfile.build:
  file.managed:
    - source: salt://docker/registry/Dockerfile.build
    - template: jinja
    - defaults:
      base: {{ golang_name }}:{{ golang_tag }}

{{ tempdir }}/docker-entrypoint.sh:
  file.managed:
    - source: salt://docker/registry/docker-entrypoint.sh
    - mode: 755

salt://docker/registry/build.sh:
  cmd.script:
    - template: jinja
    - defaults:
      name: {{ name }}
      tag: {{ tag }}
      tempdir: {{ tempdir }}

{% else %}
{% set ext_name = salt['pillar.get']('docker:images:registry:ext_name') %}
{% set tag = salt['pillar.get']('docker:images:registry:tag') %}

{{ ext_name }}:{{ tag }}:
  dockerng.image_present

{% endif %}
