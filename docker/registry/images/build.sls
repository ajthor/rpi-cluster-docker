# This file builds a local Registry image for ARM.

# Make sure we have the correct version of the Alpine ARM image.
armhf/alpine:3.4:
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

# RUn update script for registry file. This will make the registry binary
# native to ARM.
run-update-script:
  cmd.run:
    - name: /home/pi/docker/registry/update.sh v2.4.0
    - require:
      - git: https://github.com/docker/distribution-library-image.git

# Replace the Dockerfile source with an updated FROM line.
/home/pi/docker/registry/Dockerfile:
  file.replace:
    - pattern: FROM alpine:3.4
    - repl: FROM armhf/alpine:3.4
    - require:
      - git: https://github.com/docker/distribution-library-image.git
      - cmd: run-update-script

# Build the image.
armhf_registry:
  dockerng.image_present:
    - build: /home/pi/docker/registry
    - require:
      - git: https://github.com/docker/distribution-library-image.git
      - cmd: run-update-script
      - file: /home/pi/docker/registry/Dockerfile
