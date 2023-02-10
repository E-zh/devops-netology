Vector
=========

This role can install Vector on your server

Role Variables
--------------

| vars           | description                  |
|----------------|------------------------------|
| vector_version | Version of Vector to install |

Example Playbook
----------------

Role usage example:

    - hosts: servers
      roles:
         - { role: vector-role }

License
-------

MIT

Author Information
------------------

Egor Zhelobanov
