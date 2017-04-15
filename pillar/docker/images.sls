docker:
  images:
    # Set the images to use, either locally built images or images pulled from
    # Docker Hub.

    # Change the base_image tag to point to the image you want to use as the
    # basis for all subsequent builds. By default, this image is the Alpine
    # Linux image created by the docker.alpine.build function.
    - base:
      - name: alpine

    - alpine:
      - name: alpine
      - ext: resin/raspberrypi3-alpine
      - tag: 3.5.2
      - rootfs_url: https://nl.alpinelinux.org/alpine/v3.5/releases/armhf/alpine-minirootfs-3.5.2-armhf.tar.gz

    # This is the raspbian image taken from resin's official docker hub image.
    - raspbian:
      - name: resin/rpi-raspbian

    - node:
      - name: node
      - ext: resin/raspberrypi3-alpine-node
      - tag: 7.7.3
      - download_url: http://resin-packages.s3.amazonaws.com/node/v7.7.3/node-v7.7.3-linux-alpine-armhf.tar.gz
      - sha256: 498357b1094b15943161ff591482f65b82e0a6b1eee9667cbf94996d64af340b

    - python:
      - name: python
      # You need to change this external image to use
      # `resin/raspberrypi3-alpine-python` if you are using python version 2.7
      # or lower.
      - ext: resin/raspberrypi3-alpine-python3
      - tag: 3.6.0
      - download_url: http://resin-packages.s3.amazonaws.com/python/v3.6.0/Python-3.6.0.linux-alpine-armhf.tar.gz
      - sha256: 01e9faafa87d5f5ca49d50971a4a1eead18982f9e2cd01880a3651a1bdbfc9f1

    - golang:
      - name: golang
      - ext: resin/raspberrypi3-alpine-golang
      - tag: 1.8
      - download_url: http://resin-packages.s3.amazonaws.com/golang/v1.8/go1.8.linux-alpine-armhf.tar.gz
      - sha256: d9759ca7bef54e6ca4da6fc690481c51604ded60ad2265facf1986121bcc1fa0

    # Docker registry image, used to distribute built images among the cluster.
    - registry:
      - name: registry
      - ext: vdavy/registry-arm
      - tag: 2.6.1
