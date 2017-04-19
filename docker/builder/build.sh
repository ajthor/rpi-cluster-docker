#!/bin/sh

# Exmaple build.sh file.

REGISTRY_URL={{ registry_url }}

IMAGE_NAME={{ name }}
IMAGE_PREFIX={{ prefix }}
IMAGE_VERSION={{ version }}

TEMPDIR=‘mktemp -d -t builder.XXXXXX‘

# Check if prefix or registry url are set. if they are, prepend them to the
# image name.
if [ ! -z ${IMAGE_PREFIX} ] ; then
  IMAGE_NAME=$IMAGE_PREFIX/$IMAGE_NAME
fi

if [ ! -z ${REGISTRY_URL} ] ; then
  IMAGE_NAME=$REGISTRY_URL/$IMAGE_NAME
fi

echo "Building $IMAGE_NAME:build..."

# Build the builder.
docker build -t $IMAGE_NAME:build . -f Dockerfile.build

# Create a temporary container to extract binaries.
docker create --name builder $IMAGE_NAME:build

# Copy the binaries from the builder.
mkdir $TEMPDIR

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
