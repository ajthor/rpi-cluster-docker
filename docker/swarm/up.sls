# This file starts the swarm on the cluster. It is meant to be used from
# salt-call or salt-run with a command like:

# `sudo salt-run state.orchestrate swarm.up`

# Initialize the swarm on the Master. This provides a solid entry-point to the
# swarm that we can use to interact with everything. This way, you should only
# ever need to SSH into the Master.
swarm-start:
  salt.state:
    - sls: docker.swarm.manager.init
    - tgt: 'rpi-master'
    - unless:
      - docker node inspect self

# Update the Salt Mine to get the join keys for the workers and managers of the
# swarm.
update-salt-mine:
  salt.function:
    - name: mine.update
    - tgt: 'rpi-master'

# Cycle through each node in the cluster and join them to the swarm as either a
# manager or as a worker.
{% for server in salt['saltutil.runner']('cache.grains', tgt='rpi-node-?', expr_form='glob') %}

# For the first two iterations, we create managers. Just for redundancy.
{% if loop.index <= 2 %}

add-manager-{{ server }}:
  salt.state:
    - sls: docker.swarm.manager.join
    - tgt: {{ server }}

update-salt-mine-{{ server }}:
  salt.function:
    - name: mine.update
    - tgt: {{ server }}
    - require:
      - salt: add-manager-{{ server }}

# Every subsequent iteration creates a worker.
{% else %}

add-worker-{{ server }}:
  salt.state:
    - sls: docker.swarm.worker.join
    - tgt: {{ server }}

{% endif %}

{% endfor %}
