{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- import "dom0/gui-user.jinja" as gui_user -%}

"{{ slsdotpath }}-copy-root":
  file.managed:
    - name: /etc/profile.d/zzz-alias.sh
    - source: salt://{{ slsdotpath }}/files/aliases/zzz-alias.sh
    - mode: '0644'
    - user: root
    - group: root

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-root-bashrc-dircolors":
  file.replace:
    - name: /root/.bashrc
    - pattern: '^# eval '
    - repl: 'eval '

"{{ slsdotpath }}-root-bashrc-alias-ls":
  file.replace:
    - name: /root/.bashrc
    - pattern: '^# alias ls='
    - repl: 'alias ls='

"{{ slsdotpath }}-root-bashrc-append":
  file.append:
    - require:
      - file: "{{ slsdotpath }}-copy-root"
    - name: /root/.bashrc
    - text: "source /etc/profile.d/zzz-alias.sh"

"{{ slsdotpath }}-user-bashrc-append":
  file.append:
    - require:
      - file: "{{ slsdotpath }}-copy-root"
    - name: /home/user/.bashrc
    - text: "source /etc/profile.d/zzz-alias.sh"

{% endif -%}
