#!/bin/sh

IMAGE_NAME={{ name }}
IMAGE_VERSION={{ version }}

TEMPDIR={{ tempdir }}

echo "Building $IMAGE_NAME:build..."

# Build the builder.
docker build -t $IMAGE_NAME:build . -f Dockerfile.build

# Create a temporary container to extract binaries.
docker create --name builder $IMAGE_NAME:build

# Copy the binaries from the builder.
docker cp builder:/go/bin/registry $TEMPDIR/registry
docker cp builder:/go/src/github.com/docker/distribution/cmd/registry/config-example.yml $TEMPDIR/registry/config-example.yml

# Build the image.
if [ ! -z ${IMAGE_VERSION+x} ] ; then

  echo "Building $IMAGE_NAME:$IMAGE_VERSION..."
  docker build --no-cache -t $IMAGE_NAME:$IMAGE_VERSION .

fi

echo "Building $IMAGE_NAME:latest..."
docker build --no-cache -t $IMAGE_NAME:latest .

# Remove the builder.
echo "Cleaning up..."

rm -rf $TEMPDIR
docker rm -f builder
docker rmi $IMAGE_NAME:build
