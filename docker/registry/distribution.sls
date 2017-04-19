# Here, we build the registry distribution builder so that we can pull the
# registry file from it to create our own, ARM-native registry. This is roughly
# a salt version of the update script found in the registry image repo.
# https://github.com/docker/distribution-library-image

{% set golang_image = salt['pillar.get']('docker:images:golang:image') %}
{% set golang_tag = salt['pillar.get']('docker:images:golang:tag') %}

{% set tempdir = '/tmp/docker/rpi-cluster/registry' %}
{% set tempdir_builder = salt['cmd.run']('mktemp -d -t registry_builder.XXXXXX') %}

# Make sure the golang image is present.
{{ golang_image }}:{{ golang_tag }}:
  dockerng.image_present

build-golang:
  salt.state:
    - sls: docker.golang.build
    - tgt: {{ salt['pillar.get']('config:master_hostname', 'rpi-master') }}
    - onfail:
      - dockerng: {{ golang_image }}:{{ golang_tag }}

# Clone the Git repo that contains the scripts and files for the registry image.
https://github.com/docker/distribution:
  git.latest:
    - target: {{ tempdir_builder }}

# Change Dockerfile to use our golang base image.
replace-base-image:
  file.replace:
    - name: {{ tempdir_builder }}/Dockerfile
    - pattern: FROM[^\n]*?(?=\n)
    - repl: FROM {{ golang_image }}:{{ golang_tag }}
    - require:
      - git: https://github.com/docker/distribution

replace-config-file:
  file.replace:
    - name: {{ tempdir_builder }}/Dockerfile
    - pattern: COPY cmd/registry/config-dev.yml
    - repl: COPY cmd/registry/config-example.yml
    - require:
      - git: https://github.com/docker/distribution

# Build the temporary distribution image.
distribution:
  dockerng.image_present:
    - build: {{ tempdir_builder }}
    - require:
      - git: https://github.com/docker/distribution
      - file: replace-base-image
      - file: replace-config-file

# Create an image to pull the registry file from.
create-distribution-container:
  cmd.run:
    - name: docker create --name builder distribution
    - require:
      - dockerng: distribution

# Make sure the temp directory exists.
{{ tempdir }}/registry:
  file.directory:
    - makedirs: True

# Pull the registry files.
copy-registry:
  cmd.run:
    - name: docker cp builder:/go/bin/registry registry
    - cwd: {{ tempdir }}/registry
    - require:
      - cmd: create-distribution-container
      - file: {{ tempdir }}/registry

copy-config:
  cmd.run:
    - name: docker cp builder:/go/src/github.com/docker/distribution/cmd/registry/config-example.yml config-example.yml
    - cwd: {{ tempdir }}/registry
    - require:
      - cmd: create-distribution-container
      - file: {{ tempdir }}/registry

# Remove the distribution container.
builder:
  dockerng.absent:
    - force: True
    - require:
      - cmd: copy-registry
      - cmd: copy-config

# Remove the distribution image.
remove-distribution:
  dockerng.image_absent:
    - images:
      - distribution
    - require:
      - cmd: copy-registry
      - cmd: copy-config
      - dockerng: builder
