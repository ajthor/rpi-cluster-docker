# This file removes all local docker containers and images. It should not be
# used in production unless you know what you're doing.

# Stop all local docker containers.
stop-containers:
  cmd.run:
    - name: docker stop $(docker ps -a -q)

# Remove all local docker containers.
remove-containers:
  cmd.run:
    - name: docker rm $(docker ps -a -q)
    - require:
      - cmd: stop-containers

# Remove all local images.
remove-images:
  cmd.run:
    - name: docker rmi $(docker images -q)
    - require:
      - cmd: remove-containers
