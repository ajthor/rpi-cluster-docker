
{% set node_version = "7.8.0" %}

include:
  - docker.alpine.build

# Create the temp directory.
/tmp/docker/node:
  file.directory:
    - makedirs: True

# Modify the Dockerfile.
/tmp/docker/node/Dockerfile:
  file.managed:
    - source: salt://docker/node/Dockerfile
    - template: jinja

# Build the image.
rpi-cluster/node:{{ node_version }}:
  dockerng.image_present:
    - build: /tmp/docker/node
    - require:
      - file: /tmp/docker/node/Dockerfile

rpi-cluster/node:latest:
  dockerng.image_present:
    - build: /tmp/docker/node
    - require:
      - file: /tmp/docker/node/Dockerfile
