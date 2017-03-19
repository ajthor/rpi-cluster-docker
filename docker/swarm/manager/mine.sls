# Salt Mine for getting addresses and keys.
/etc/salt/minion.d/swarm.conf:
  file.managed:
    - source: salt://swarm/manager/swarm.conf
    - create: True
    - replace: True
