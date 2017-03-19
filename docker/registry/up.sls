# This file contains scripts for starting a registry image on your cluster.
# See: https://docs.docker.com/registry/deploying/ for more info.

include:
  - registry.images.build

registry:
  dockerng.runnning:
    - image: armhf_registry
    - detach: True
    - ports:
      - 5000
    - restart_policy: always
