#!/bin/sh

IMAGE_NAME={{ name }}
IMAGE_PREFIX={{ prefix }}
IMAGE_VERSION={{ version }}

echo "Building $IMAGE_NAME:build..."

# Build the builder.
docker build -t $IMAGE_PREFIX/$IMAGE_NAME:build . -f Dockerfile.build

# Create a temporary container to extract binaries.
docker create --name builder $IMAGE_PREFIX/$IMAGE_NAME:build

# Copy the binaries from the builder.
docker cp builder:/go/src/github.com/alexellis/href-counter/app ./app

# Remove the builder.
docker rm -f builder
docker rmi builder

if [ -z ${IMAGE_VERSION+x} ] ; then

  echo "No version specified, using 'latest'"

else

  echo "Building $IMAGE_NAME:$IMAGE_VERSION..."
  docker build --no-cache -t $IMAGE_PREFIX/$IMAGE_NAME:$IMAGE_VERSION .

fi

echo "Building $IMAGE_NAME:latest..."
docker build --no-cache -t $IMAGE_PREFIX/$IMAGE_NAME:latest .
