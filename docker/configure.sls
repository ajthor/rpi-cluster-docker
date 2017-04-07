# This file will configure the Docker service and manage other configuration
# settings on the targets.

{% set master_host = salt['pillar.get']('config:master_host', 'rpi-master.local') %}
{% set master_hostname = salt['pillar.get']('config:master_hostname', 'rpi-master.local') %}

# Add registry configuration.
# {% if salt['pillar.get']('docker:use_tls', true) %}

# Install pip packages.
pyopenssl:
  pip.installed

create-tls-ca:
  module.run:
    - name: tls.create_ca
    - ca_name: {{ master_host }}
    - ca_filename: ca.pem
    - bits: 4096

create-tls-csr:
  module.run:
    - name: tls.create_csr
    - ca_name: {{ master_host }}
    - csr_filename: server.csr
    - cert_type: server
    - CN: {{ master_hostname }}
    - bits: 4096

create-tls-signed-cert:
  module.run:
    - name: tls.create_ca_signed_cert
    - CN: {{ master_hostname }}
    - cert_type: server

# openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
{% else %}

/etc/default/docker:
  file.line:
    match: DOCKER_OPTS
    mode: replace
    content: DOCKER_OPTS="--insecure-registry {{ master_hostname }}:5000"

{% endif %}

# Ensure that the Docker service is running and enabled to start on boot and
# configure the default user 'pi' to be a member of the 'docker' group.
configure-docker-installation:
  service.running:
    - name: docker
    - enable: True
  group.present:
    - name: docker
    - addusers:
      - pi
