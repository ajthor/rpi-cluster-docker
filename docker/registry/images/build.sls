# This file builds a local Registry image for ARM. It uses the official
# registry distribution repo as a base and makes some small replacements in the
# dockerfile to use the golang image specified in the pillar.

{%- set golang_tag = salt['pillar.get']('docker:images:golabg:tag', 'rpi-cluster/golang') -%}
{%- set golang_version = salt['pillar.get']('docker:images:golang:version', '1.8') -%}
{%- set tmpdir = '/tmp/docker/rpi-cluster/registry' %}

# Make sure the golang image is present.
{{ golang_tag }}:{{ golang_version }}:
  dockerng.image_present

build-golang:
  salt.state:
    - sls: docker.golang.build
    - tgt: {{ salt['pillar.get']('config:master_hostname', 'rpi-master') }}
    - onfail:
      - dockerng: {{ golang_tag }}:{{ golang_version }}

# Clone the Git repo that contains the scripts and files for the registry image.
https://github.com/docker/distribution-library-image:
  git.latest:
    - target: {{ tmpdir }}/registry

# Change Dockerfile to use our golang base image.
replace-base-image:
  file.replace:
    - pattern: FROM[^\n]*?(?=\n)
    - repl: FROM {{ golang_tag }}:{{ golang_version }}
    - require:
      - git: https://github.com/docker/distribution-library-image

replace-config-file:
  file.replace:
    - pattern: COPY cmd/registry/config-dev.yml
    - repl: COPY cmd/registry/config-example.yml
    - require:
      - git: https://github.com/docker/distribution-library-image

# Build the distribution image.
build-distribution-image:
  dockerng.image_present:
    - name: rpi-cluster/registry:latest
    - build: {{ tmpdir }}/registry
    - require:
      - git: https://github.com/docker/distribution-library-image
      - file: {{ tmpdir }}/registry/Dockerfile

# Build the image.
rpi-cluster/registry:latest:
  dockerng.image_present:
    - build: /home/pi/docker/registry
    - require:
      - git: https://github.com/docker/distribution-library-image
      - file: /home/pi/docker/registry/Dockerfile
