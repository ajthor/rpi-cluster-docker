docker:
  images:
    # Set the images to use, either locally built images or images pulled from
    # Docker Hub.
    - alpine:
      - tag: rpi-cluster/alpine
      - ext_tag: resin/raspberrypi3-alpine
      - version: 3.5.2
      # You only need to specify this if the `use_external_images` is `True`.
      - rootfs_url: https://nl.alpinelinux.org/alpine/v3.5/releases/armhf/alpine-minirootfs-3.5.2-armhf.tar.gz

    - node:
      - tag: rpi-cluster/node
      - ext_tag: resin/raspberrypi3-alpine-node
      - version: 7.8.0
      - sha256: 498357b1094b15943161ff591482f65b82e0a6b1eee9667cbf94996d64af340b

    - python:
      - tag: rpi-cluster/python
      # You need to change this external image to use
      # `resin/raspberrypi3-alpine-python` if you are using python version 2.7
      # or lower.
      - ext_tag: resin/raspberrypi3-alpine-python3
      - version: 3.6.0
      - sha256: 01e9faafa87d5f5ca49d50971a4a1eead18982f9e2cd01880a3651a1bdbfc9f1

    - golang:
      - tag: rpi-cluster/golang
      - ext_tag: resin/raspberrypi3-alpine-golang
      - version: 1.8
      - sha256: d9759ca7bef54e6ca4da6fc690481c51604ded60ad2265facf1986121bcc1fa0

    - registry:
      - tag: rpi-cluster/registry
      - ext_tag: vdavy/registry-arm
      - version: 2.6.1
