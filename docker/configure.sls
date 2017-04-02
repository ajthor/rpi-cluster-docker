# This file will configure the Docker service and manage other configuration
# settings on the targets. 

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
