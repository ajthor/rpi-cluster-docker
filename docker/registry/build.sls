# This file builds a local Registry image for ARM. It uses the official
# registry distribution repo as a base and makes some small replacements in the
# dockerfile to use the golang image specified in the pillar.

{%- set alpine_tag = salt['pillar.get']('docker:images:alpine:tag', 'rpi-cluster/alpine') -%}
{%- set alpine_version = salt['pillar.get']('docker:images:alpine:version', '3.5.2') -%}

{%- set golang_tag = salt['pillar.get']('docker:images:golang:tag', 'rpi-cluster/golang') -%}
{%- set golang_version = salt['pillar.get']('docker:images:golang:version', '1.8') -%}

{%- set registry_tag = salt['pillar.get']('docker:images:registry:tag', 'rpi-cluster/registry') -%}
{%- set registry_version = salt['pillar.get']('docker:images:registry:version', '2.5') -%}

{%- set tmpdir = '/tmp/docker/rpi-cluster/registry' %}
{%- set tmpdir_builder = '/tmp/docker/rpi-cluster/registry_builder' %}

# Here, we build the registry distribution builder so that we can pull the
# registry file from it to create our own, ARM-native registry. This is roughly
# a salt version of the update script found in the registry image repo.
# https://github.com/docker/distribution-library-image

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
https://github.com/docker/distribution:
  git.latest:
    - target: {{ tmpdir_builder }}

# Change Dockerfile to use our golang base image.
replace-base-image:
  file.replace:
    - name: {{ tmpdir_builder }}/Dockerfile
    - pattern: FROM[^\n]*?(?=\n)
    - repl: FROM {{ golang_tag }}:{{ golang_version }}
    - require:
      - git: https://github.com/docker/distribution

replace-config-file:
  file.replace:
    - name: {{ tmpdir_builder }}/Dockerfile
    - pattern: COPY cmd/registry/config-dev.yml
    - repl: COPY cmd/registry/config-example.yml
    - require:
      - git: https://github.com/docker/distribution

# Build the temporary distribution image.
distribution:
  dockerng.image_present:
    - build: {{ tmpdir_builder }}
    - require:
      - git: https://github.com/docker/distribution
      - file: replace-base-image
      - file: replace-config-file

# Create an image to pull the registry file from.
docker create --name builder distribution:
  cmd.run

# Pull the registry files.
docker cp builder:/go/bin/registry registry:
  cmd.run:
    - cwd: {{ tmpdir }}/registry

docker cp builder:/go/src/github.com/docker/distribution/cmd/registry/config-example.yml registry:
  cmd.run:
    - cwd: {{ tmpdir }}/registry

# Remove the distribution container.
builder:
  dockerng.absent:
    - force: True

# Now that we have the registry binary from the builder, we can go through the
# process of creating our own registry image. We need to copy the entrypoint
# file and the Dockerfile over to the temporary directory and build our new
# image.

# Copy files to temp dir.
{{ tmpdir }}/Dockerfile:
  file.managed:
    - source: salt://docker/registry/Dockerfile
    - makedirs: True
    - template: jinja
    - defaults:
      alpine_tag: {{ alpine_tag }}
      alpine_version: {{ alpine_version }}

{{ tmpdir }}/docker-entrypoint.sh:
  file.managed:
    - source: salt://docker/registry/docker-entrypoint.sh
    - makedirs: True

{{ registry_tag }}:{{ registry_version}}:
  dockerng.image_present:
    - build: {{ tmpdir }}
    - require:
      - file: {{ tmpdir }}/Dockerfile
      - file: {{ tmpdir }}/docker-entrypoint.sh
