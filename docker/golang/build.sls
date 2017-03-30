# This file takes the image from docker-library and builds it specifically
# using our base alpine image.

{% set golang_version = 1.8 %}
{% set golang_folder = "golang/1.8/alpine/" %}

include:
  - docker.alpine.build

# Create the temp directory.
/tmp/docker/alpine:
  file.directory:
    - makedirs: True

# Download the Github repo.
https://github.com/docker-library/golang.git:
  git.latest:
    - target: /tmp/docker/golang
    - force_clone: True

# Modify the Dockerfile.
/tmp/docker/{{ golang_folder }}/Dockerfile:
  file.replace:
    - pattern: FROM[^\n]*?(?=\n)
    - repl: FROM rpi-cluster/alpine:latest
    - require:
      - git: https://github.com/docker-library/golang.git

# Build the image.
rpi-cluster/golang:{{ golang_version }}:
  dockerng.image_present:
    - build: /tmp/docker/{{ golang_folder }}
    - require:
      - git: https://github.com/docker-library/golang.git
      - file: /tmp/docker/{{ golang_folder }}/Dockerfile

rpi-cluster/golang:latest:
  dockerng.image_present:
    - build: /tmp/docker/{{ golang_folder }}
    - require:
      - git: https://github.com/docker-library/golang.git
      - file: /tmp/docker/{{ folder }}/Dockerfile
