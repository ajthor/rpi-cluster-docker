# This file builds a local Registry image for ARM.

armhf/alpine:
  dockerng.image_present

/tmp/docker/registry:
  file.directory:
    - makedirs: True

/tmp/docker/update.sh:
  file.managed:
    - source: salt://docker/registry/images/update.sh
    - mode: 755

/tmp/docker/docker-entrypoint.sh:
  file.managed:
    - source: salt://docker/registry/images/docker-entrypoint.sh
    - mode: 755

/tmp/docker/Dockerfile:
  file.managed:
    - source: salt://docker/registry/images/Dockerfile

/tmp/docker/registry/config-example.yml:
  file.managed:
    - source: salt://docker/registry/images/config-example.yml

/tmp/docker/update.sh v2.6:
  cmd.run:
    - require:
      - file: /tmp/docker/registry
      - file: /tmp/docker/update.sh

# Clone the Git repo that contains the scripts and files for the registry image.
# https://github.com/docker/distribution-library-image:
#   git.latest:
#     - target: /home/pi/docker/registry
#     - bare: True

# RUn update script for registry file. This will make the registry binary
# native to ARM.
# run-update-script:
#   cmd.run:
#     - name: /home/pi/docker/registry/update.sh v2.4.0
#     - require:
#       - git: https://github.com/docker/distribution-library-image.git

# Replace the Dockerfile source with an updated FROM line.
# /home/pi/docker/registry/Dockerfile:
#   file.replace:
#     - pattern: FROM alpine
#     - repl: FROM armhf/alpine
#     - reguire:
#       - git: https://github.com/docker/distribution-library-image

# Build the image.
# armhf_registry:
#   dockerng.image_present:
#     - build: /home/pi/docker/registry
#     - require:
#       - git: https://github.com/docker/distribution-library-image
#       - file: /home/pi/docker/registry/Dockerfile
