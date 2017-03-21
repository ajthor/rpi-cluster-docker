
# Copy the Dockerfile and entrypoint.
/tmp/docker/builder/Dockerfile:
  file.managed:
    - source: salt://docker/images/builder/Dockerfile
    - makedirs: True

/tmp/docker/builder/docker_entrypoint.sh:
  file.managed:
    - source: salt://docker/images/builder/docker_entrypoint.sh
    - makedirs: True

# Create the Docker builder image.
builder:latest:
  dockerng.image_present:
    - build: /tmp/docker/builder
    - require:
      - file: /tmp/docker/builder/Dockerfile
      - file: /tmp/docker/builder/docker_entrypoint.sh
