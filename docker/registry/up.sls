# This file contains scripts for starting a registry image on your cluster.
# See: https://docs.docker.com/registry/deploying/ or
# https://docs.docker.com/registry/#tldr for more info.


{%- set tag = salt['pillar.get']('docker:images:registry:tag', 'rpi-cluster/registry') -%}
{%- set version = salt['pillar.get']('docker:images:registry:version', '2.6.1') %}

# Make sure the registry image is present.
{{ tag }}:{{ version }}:
  dockerng.image_present

build-registry:
  salt.state:
    - sls: docker.registry.build
    - tgt: {{ salt['pillar.get']('config:master_hostname', 'rpi-master') }}
    - onfail:
      - dockerng: {{ tag }}:{{ version }}

registry:
  dockerng.running:
    - image: {{ tag }}:{{ version }}
    - detach: True
    - ports:
      - 5000
    - restart_policy: always
