#!/usr/bin/env python3

import os
import sys

#bash_command = ["cd ~/netology/devops-netology", "git status"]
#result_os = os.popen(' && '.join(bash_command)).read()
#for result in result_os.split('\n'):
#    if result.find('modified') != -1:
#        prepare_result = result.replace('\tmodified:   ', '')
#        print(prepare_result)

path = "/home/vagrant/netology/devops-netology"
if len(sys.argv) > 1:
    path = sys.argv[1]

bash_command = ["cd "+path, "git status 2>&1"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('fatal') != -1:
        print("Directory " +path+" is not a git repository")
    elif result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:', '').strip()
        print(os.path.join(path, prepare_result))