# This file is meant to be run using Salt orchestrate, using a command such as:
# `sudo salt-run state.orchestrate docker.bootstrap`

# Configure pillar.
configure-pillar:
  salt.state:
    - sls: docker.pillar
    - tgt: 'rpi-master'

# Install Docker.
install-docker:
  salt.state:
    - sls: docker.install
    - tgt: '*'

# Configure Docker.
configure-docker:
  salt.state:
    - sls: docker.configure
    - tgt: '*'
