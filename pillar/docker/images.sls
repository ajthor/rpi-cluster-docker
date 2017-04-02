docker:
  images:
    # Set the images to use, either locally built images or images pulled from
    # Docker Hub.
    - alpine:
      - tag: rpi-cluster/alpine
      - ext_tag: resin/raspberrypi3-alpine
      - version: 3.5.2

    - node:
      - tag: rpi-cluster/node
      - ext_tag: resin/raspberrypi3-alpine-node
      - version: 7.8.0

    - python:
      - tag: rpi-cluster/python
      - ext_tag: resin/raspberrypi3-alpine-python
      - version: 2.7

    - python3:
      - tag: rpi-cluster/python
      - ext_tag: resin/raspberrypi3-alpine-python3
      - version: 3

    - golang:
      - tag: rpi-cluster/golang
      - ext_tag: resin/raspberrypi3-alpine-golang
      - version: 1.8
