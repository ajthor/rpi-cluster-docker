# This file contains scripts for starting a registry image on your cluster.
# See: https://docs.docker.com/registry/deploying/ or
# https://docs.docker.com/registry/#tldr for more info.

registry:
  dockerng.running:
    - image: vdavy/registry-arm:2.2.0
    - detach: True
    - ports:
      - 5000
    - restart_policy: always
