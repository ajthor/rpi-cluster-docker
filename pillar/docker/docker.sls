docker:
  # Determine whether or not to use external images, pulled from Docker Hub.
  # The image tags are stored in the images config file. By default, the images
  # are pulled from hypriot's images. 
  use_external_images: False
  # Use TLS certificates to verify local registry and secure the cluster.
  use_tls: True
