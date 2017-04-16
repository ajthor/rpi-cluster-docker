#!/bin/sh

IMAGE_NAME={{ image }}
IMAGE_TAG={{ tag }}

TEMPDIR={{ tempdir }}

echo "Building $IMAGE_NAME:build..."

# Build the builder.
docker build -t $IMAGE_NAME:build . -f Dockerfile.build

# Create a temporary container to extract binaries.
docker create --name builder $IMAGE_NAME:build

# Copy the binaries from the builder.
mkdir $TEMPDIR/registry
docker cp builder:/go/bin/registry $TEMPDIR/registry/registry
docker cp builder:/go/src/github.com/docker/distribution/cmd/registry/config-example.yml $TEMPDIR/registry/config-example.yml

# Build the image.
echo "Building $IMAGE_NAME:latest..."

docker build --no-cache -t $IMAGE_NAME:latest .

# Make sure the last command completed successfully.
if [ "$?" -eq 0 ]; then
  
  if [ ! -z ${IMAGE_TAG+x} ] ; then
    echo "Building $IMAGE_NAME:$IMAGE_TAG..."
    docker build --no-cache -t $IMAGE_NAME:$IMAGE_TAG .
  fi

  # Remove the builder.
  echo "Cleaning up..."

  rm -rf $TEMPDIR
  docker rm -f builder
  docker rmi $IMAGE_NAME:build

else
  exit "$?"

fi
