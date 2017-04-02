docker:
  images:
    # Set the images to use, either locally built images or images pulled from
    # Docker Hub.
{% if not salt['pillar.get']('docker:use_external_images', false) %}
    # Locally-built images:
    - base_image:
      - tag: rpi-cluster/alpine
      - version: latest
    - node:
      - tag: rpi-cluster/node
      - version: latest
    - python:
      - tag: rpi-cluster/python
      - version: latest
    - golang:
      - tag: rpi-cluster/golang
      - version: latest

{% else %}
    # Images pulled from Docker Hub:
    - base_image:
      - tag: hypriot/rpi-alpine
      - version: latest
    - node:
      - tag: hypriot/rpi-node
      - version: latest
    - python:
      - tag: hypriot/rpi-python
      - version: latest
    - golang:
      - tag: hypriot/rpi-golang
      - version: latest

{% endif %}
