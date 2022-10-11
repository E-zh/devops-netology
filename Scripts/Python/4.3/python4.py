#!/usr/bin/env python3

import socket
import time
import os
import sys
import json
import yaml

path = os.path.dirname(os.path.abspath(sys.argv[0]))
hosts = {'drive.google.com': '0.0.0.0', 'mail.google.com': '0.0.0.0', 'google.com': '0.0.0.0'}
i = 1

while i <= 50:
  for host in hosts:
    time.sleep(2)
    ip = socket.gethostbyname(host)
    print(host + ' - ' + ip)
    if ip != hosts[host]:
        print('[ERROR] ' + host + ' IP mistmatch: ' + str(hosts[host]) + ' ' + ip)
        hosts[host] = ip
    with open(os.path.join(path, "service.json"), 'w') as file_json:
        file_json.write(json.dumps(hosts))
    with open(os.path.join(path, "service.yml"), 'w') as file_yml:
        file_yml.write(yaml.dump(hosts, explicit_start=True, explicit_end=True))
  i+=1