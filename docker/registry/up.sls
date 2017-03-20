# This file contains scripts for starting a registry image on your cluster.
# See: https://docs.docker.com/registry/deploying/ or
# https://docs.docker.com/registry/#tldr for more info.

include:
  - docker.registry.images.build

registry:
  dockerng.running:
    - image: armhf_registry:latest
    - detach: True
    - ports:
      - 127.0.0.1:5000:5000
    - restart_policy: always
