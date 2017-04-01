# This file is meant to be run using Salt orchestrate, using a command such as:
# `sudo salt-run state.orchestrate docker.bootstrap`

# Install Docker.
install-docker:
  salt.state:
    - sls: docker.install
    - tgt: '*'

configure-docker:
  salt.state:
    - sls: docker.configure
    - tgt: '*'
