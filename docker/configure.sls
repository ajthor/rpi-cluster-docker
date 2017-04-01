# This will configure the Docker pillar on the master and also install Docker
# on every minion in the cluster.

{% set files = ['docker/docker', 'docker/images'] %}

{% if grains['host'] == 'rpi-master' %}

# Add pillar files.
{% for f in files %}
/srv/pillar/{{ f }}.sls:
  file.managed:
    - source: salt://pillar/{{ f }}.sls
    - template: jinja
    - makedirs: True
    - unless: test -f "/srv/pillar/{{ f }}.sls"
{% endfor %}

/srv/pillar/top.sls:
  file.append:
    - source: salt://pillar/docker.tmpl
    - template: jinja
    - defaults:
        # NOTE: Need extra spaces here to make this work. Add an extra tab for
        # defaults in file.append states using jinja templating.
        # https://github.com/saltstack/salt/issues/18686
        files: {{ files }}
    - require:
{% for f in files %}
      - file: /srv/pillar/{{ f }}.sls
{% endfor %}

# Update the Salt pillar.
update-salt-pillar:
  salt.function:
    - name: saltutil.refresh_pillar
    - tgt: 'rpi-master'
    - onchanges:
{% for f in files %}
      - file: /srv/pillar/{{ f }}.sls
{% endfor %}
    - require:
      - file: /srv/pillar/top.sls
{% for f in files %}
      - file: /srv/pillar/{{ f }}.sls
{% endfor %}

{% endif %}
