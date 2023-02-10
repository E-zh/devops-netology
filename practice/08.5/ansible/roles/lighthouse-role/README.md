Lighthouse
=========

This role can install Lighthouse on your server

Role Variables
--------------

| vars                       | description                       |
|----------------------------|-----------------------------------|
| lighthouse_vcs             | Path on github to this repository |
| lighthouse_access_log_name | Path to dir for logs              |
| nginx_user_name            | User name of nginx service        |

Example Playbook
----------------

Role usage example:

    - hosts: servers
      roles:
         - { role: lighthouse-role }

License
-------

MIT

Author Information
------------------

Egor Zhelobanov
