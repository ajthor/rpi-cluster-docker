# ----------------------------------------
# Build a minimal distribution container.
#
# First, we need to create the registry binary, which we will use in our new
# registry image.
FROM rpi-cluster/golang:1.8 AS builder

# Set environment variables.
ENV DISTRIBUTION_DIR /go/src/github.com/docker/distribution

# Install dependencies.
RUN apk add --no-cache \
    ca-certificates \
  && apk add --no-cache --virtual .build-deps \
    gcc \
    g++ \
    make \
    git

# Set the working directory to the distribution directory.
WORKDIR $DISTRIBUTION_DIR

# Clone the git repo into the container.
RUN git clone https://github.com/docker/distribution .

# Copy config to registry folder.
RUN mkdir -p /etc/docker/registry \
  && cp ./cmd/registry/config-dev.yml /etc/docker/registry/config.yml

# Build the registry binary.
RUN make PREFIX=/go clean binaries

# ----------------------------------------
# Build the registry.
#
# Once we have the registry binary from the builder, we can go through the process of creating our own registry image.
FROM rpi-cluster/alpine:latest

# Install dependencies.
RUN apk add --no-cache \
    ca-certificates \
  && apk add --no-cache --virtual .build-deps \
    apache2-utils

# Copy the registry binary from the builder.
COPY --from=builder /go/bin/registry /bin/registry
# Copy the default config from the builder.
COPY --from=builder /go/src/github.com/docker/distribution/cmd/registry/config-example.yml /etc/docker/registry/config.yml

# Set the volume.
VOLUME ["/var/lib/registry"]

# Expose ports.
EXPOSE 5000

# Copy the entrypoint script.
COPY docker-entrypoint.sh /entrypoint.sh
# Set the entrypoint script.
ENTRYPOINT ["/entrypoint.sh"]

# Command.
CMD ["/etc/docker/registry/config.yml"]
