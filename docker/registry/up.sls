# This file contains scripts for starting a registry image on your cluster.
# See: https://docs.docker.com/registry/deploying/ or
# https://docs.docker.com/registry/#tldr for more info.


{% set name = salt['pillar.get']('docker:images:registry:name', 'rpi-cluster/registry') -%}
{% set tag = salt['pillar.get']('docker:images:registry:tag') %}

# Make sure the registry image is present.
{{ name }}:{{ tag }}:
  dockerng.image_present

build-registry:
  salt.state:
    - sls: docker.registry.build
    - tgt: {{ salt['pillar.get']('config:master_hostname', 'rpi-master') }}
    - onfail:
      - dockerng: {{ name }}:{{ tag }}

registry:
  dockerng.running:
    - image: {{ name }}:{{ tag }}
    - detach: True
    - ports:
      - 5000
    - restart_policy: always
