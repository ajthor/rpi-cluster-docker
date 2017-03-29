# This file takes the image from docker-library and builds it specifically
# using our base alpine image.

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
/tmp/docker/golang/1.8/alpine/Dockerfile:
  file.replace:
    - pattern: FROM[^\n]*?(?=\n)
    - repl: FROM rpi-cluster/alpine:latest
    - require:
      - git: https://github.com/docker-library/golang.git

# Build the image.
rpi-cluster/golang:1.8:
  dockerng.image_present:
    - build: /tmp/docker/golang/1.8/alpine
    - require:
      - git: https://github.com/docker-library/golang.git
      - file: /tmp/docker/golang/1.8/alpine/Dockerfile
