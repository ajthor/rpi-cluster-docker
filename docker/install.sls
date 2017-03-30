# This state file installs Docker using the Docker install script from
# https://get.docker.com, and configures the Docker service and users for use
# in the cluster.

# Run the Docker install script.
docker-bootstrap:
  cmd.run:
    - name: curl -o bootstrap-docker.sh -sSL https://get.docker.com
    - cwd: /tmp
    - unless: which docker

docker-install:
  cmd.run:
    - name: sh bootstrap-docker.sh
    - cwd: /tmp
    - unless: which docker
    - require:
      - cmd: docker-bootstrap

# Ensure that the Docker service is running and enabled to start on boot.
docker-service:
  service.running:
    - name: docker
    - enable: True

# Configure the default user 'pi' to be a member of the 'docker' group.
docker-user:
  group.present:
    - name: docker
    - addusers:
      - pi

# Add pillar data.
{%- set pillar_files = ['docker.sls', 'images.sls'] -%}
{%- for file in pillar_files %}
/srv/pillar/docker/{{ file }}:
  file.managed:
    - source: salt://pillar/docker/{{ file }}
{% endfor -%}
