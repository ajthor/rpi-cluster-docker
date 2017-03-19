# This file configures the workers and joins them to the swarm.

{% set join_token = salt['mine.get']('*', 'worker_join_token').items()[0][1] %}
{% set join_ip = salt['mine.get']('*', 'manager_ip').items()[0][1][0] %}

# Join the Docker swarm.
swarm-join-worker:
  cmd.run:
    - name: 'docker swarm join --token {{ join_token }} {{ join_ip }}:2377'
