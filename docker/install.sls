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

# Ensure that the Docker service is running and enabled to start on boot and
# configure the default user 'pi' to be a member of the 'docker' group.
configure-docker-installation:
  service.running:
    - name: docker
    - enable: True
  group.present:
    - name: docker
    - addusers:
      - pi
