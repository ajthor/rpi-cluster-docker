# This file forcibly removes the nodes from the swarm. It is experimental and
# should not be used in production.

{% for server in salt['saltutil.runner']('cache.grains', tgt='*', expr_form='glob') %}

# We need to clear the salt mine so that we can use new values, such as IP
# addresses and join keys.
clear-salt-mine:
  salt.function:
    - name: mine.flush

# Leave the swarm, by force if necessary. Not the best approach, and will fix in a future update.
swarm-leave-{{ server }}:
  cmd.run:
    - name: docker swarm leave
    - onfail:
      cmd: swarm-demote-{{ server }}

swarm-demote-{{ server }}:
  cmd.run:
    - name: docker node demote self
    - onfail:
      - cmd: swarm-leave-force-{{ server }}

swarm-leave-force-{{ server }}:
  cmd.run:
    - name: docker swarm leave --force


{% endfor %}
