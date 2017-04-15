docker:
  # Use this option to set the number of managers that the Docker Swarm should
  # have. This number should form a quorum of managers, and should be an odd
  # number. This number should scale with the size of your cluster, and
  # increases the fault tolerance of your swarm.
  swarm_managers: 3
  
  # Use this option to specify a custom account for your images. If an account
  # is specified, all images built will be tagged with the account,
  # "account/name:tag".
  # account: rpi-cluster

  # Determine whether or not to use external images, pulled from Docker Hub.
  # The image tags are stored in the images config file. By default, the images
  # are pulled from hypriot's images.
  use_external_images: False

  # Use TLS certificates to verify local registry and secure the cluster.
  use_tls: True
