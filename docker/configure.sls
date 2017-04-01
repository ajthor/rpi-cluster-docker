# This will configure the Docker pillar on the master and also install Docker
# on every minion in the cluster.

{% set files = ['docker', 'images'] %}

{% if grains['host'] == 'rpi-master' %}
# Ensure pillar directory exists.
/srv/pillar/docker:
  file.directory:
    - makedirs: True

# Add pillar files.
{% for f in files %}
/srv/pillar/docker/{{ f }}.sls:
  file.managed:
    - source: salt://pillar/docker/{{ f }}.sls
    - unless: test -f "/srv/pillar/docker/{{ f }}.sls"
{% endfor %}

/srv/pillar/top.sls:
  file.append:
    - source: salt://pillar/docker.tmpl
    - template: jinja
    - defaults:
      - files: {{ files }}
    - require:
{% for f in files %}
      - file: /srv/pillar/docker/{{ f }}.sls
{% endfor %}

# Update the Salt pillar.
update-salt-pillar:
  salt.function:
    - name: saltutil.refresh_pillar
    - tgt: 'rpi-master'
    - onchanges:
{% for f in files %}
      - file: /srv/pillar/docker/{{ f }}.sls
{% endfor %}
    - require:
      - file: /srv/pillar/top.sls
{% for f in files %}
      - file: /srv/pillar/docker/{{ f }}.sls
{% endfor %}

{% endif %}
