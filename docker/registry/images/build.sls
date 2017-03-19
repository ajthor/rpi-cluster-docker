

# Make sure we have the latest version of the Alpine ARM image.
armhf/alpine:latest:
  dockerng.image_present

# Ensure the directory exists.
/home/pi/docker/ros:
  file.directory:
    - makedirs: True
    
# Clone the Git repo that contains the scripts and files for the registry image.
https://github.com/docker/distribution-library-image:
  git.latest:
    - target: /home/pi/docker/registry
    - bare: True

# Replace the Dockerfile source with an updated FROM line.
/home/pi/docker/registry/Dockerfile:
  file.replace:
    - pattern: FROM alpine
    - repl: FROM armhf/alpine
    - reguire:
      - git: https://github.com/docker/distribution-library-image

# Build the image.
armhf_registry:
  dockerng.image_present:
    - build: /home/pi/docker/registry
    - require:
      - git: https://github.com/docker/distribution-library-image
      - file: /home/pi/docker/registry/Dockerfile
