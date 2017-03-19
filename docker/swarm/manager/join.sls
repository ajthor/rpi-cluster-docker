# This file configures the managers and joins them to the swarm.

{% set join_token = salt['mine.get']('*', 'manager_join_token').items()[0][1] %}
{% set join_ip = salt['mine.get']('*', 'manager_ip').items()[0][1][0] %}

include:
  - swarm.manager.mine

swarm-join-manager:
  cmd.run:
    - name: 'docker swarm join --token {{ join_token }} {{ join_ip }}:2377'
