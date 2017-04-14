# This state file installs Docker using the Docker install script from
# https://get.docker.com, and configures the Docker service and users for use
# in the cluster.

# Run the Docker install script.
curl -o bootstrap-docker.sh -sSL https://get.docker.com:
  cmd.run:
    - cwd: /tmp
    - unless: which docker

sh bootstrap-docker.sh:
  cmd.run:
    - cwd: /tmp
    - unless: which docker
    - require:
      - cmd: curl -o bootstrap-docker.sh -sSL https://get.docker.com

# Install pip packages.
docker-py:
  pip.installed

docker-compose:
  pip.installed
