#!/usr/bin/env python3

import socket
import time

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
  i+=1