# This file contains scripts for starting a registry image on your cluster.
# See: https://docs.docker.com/registry/deploying/ for more info.

start-registry:
  dockerng.runnning:
    - name: registry
    - image: registry:2
    - detach: True
    - ports:
      - 5000
    - restart_policy: always
