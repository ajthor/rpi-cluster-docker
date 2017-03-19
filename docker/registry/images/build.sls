# This file builds a local Registry image for ARM.

# Make sure we have the correct version of the Alpine ARM image.
container4armhf/armhf-alpine:3.4:
  dockerng.image_present

# Ensure the directory exists.
/home/pi/docker/registry:
  file.directory:
    - makedirs: True

# Clone the Git repo that contains the scripts and files for the registry image.
https://github.com/docker/distribution-library-image.git:
  git.latest:
    - target: /home/pi/docker/registry
    - branch: master

# Replace the Dockerfile source with an updated FROM line.
/home/pi/docker/registry/Dockerfile:
  file.replace:
    - pattern: FROM alpine:3.4
    - repl: FROM osrf/ubuntu_armhf:trusty
    - require:
      - git: https://github.com/docker/distribution-library-image.git

# Build the image.
armhf_registry:
  dockerng.image_present:
    - build: /home/pi/docker/registry
    - require:
      - git: https://github.com/docker/distribution-library-image.git
      - file: /home/pi/docker/registry/Dockerfile
