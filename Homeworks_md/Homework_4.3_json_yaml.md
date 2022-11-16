# devops-netology
### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис.  
Ответ:
```json
{
   "info": "Sample JSON output from our service\t",
   "elements": [
      {
         "name": "first",
         "type": "server",
         "ip": 7175
      },
      {
         "name": "second",
         "type": "proxy",
         "ip": "71.78.22.43"
      }
   ]
}
```

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт (уменьшил число опросов до 10):
```python
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

while i <= 10:
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
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~$ python3 python4.py
drive.google.com - 209.85.233.194
[ERROR] drive.google.com IP mistmatch: 0.0.0.0 209.85.233.194
mail.google.com - 209.85.233.19
[ERROR] mail.google.com IP mistmatch: 0.0.0.0 209.85.233.19
google.com - 74.125.205.113
[ERROR] google.com IP mistmatch: 0.0.0.0 74.125.205.113
drive.google.com - 209.85.233.194
mail.google.com - 209.85.233.17
[ERROR] mail.google.com IP mistmatch: 209.85.233.19 209.85.233.17
google.com - 74.125.205.100
[ERROR] google.com IP mistmatch: 74.125.205.113 74.125.205.100
drive.google.com - 209.85.233.194
mail.google.com - 209.85.233.17
google.com - 74.125.205.100
drive.google.com - 209.85.233.194
mail.google.com - 209.85.233.17
google.com - 74.125.205.100
drive.google.com - 209.85.233.194
mail.google.com - 209.85.233.17
google.com - 74.125.205.100
drive.google.com - 209.85.233.194
mail.google.com - 209.85.233.17
google.com - 74.125.205.100
drive.google.com - 209.85.233.194
mail.google.com - 209.85.233.17
google.com - 74.125.205.100
drive.google.com - 209.85.233.194
mail.google.com - 209.85.233.17
google.com - 74.125.205.100
drive.google.com - 209.85.233.194
mail.google.com - 209.85.233.17
google.com - 74.125.205.100
drive.google.com - 209.85.233.194
mail.google.com - 209.85.233.17
google.com - 74.125.205.100
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{"drive.google.com": "209.85.233.194", "mail.google.com": "209.85.233.17", "google.com": "74.125.205.100"}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
---
drive.google.com: 209.85.233.194
google.com: 74.125.205.100
mail.google.com: 209.85.233.17
...
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Ваш скрипт:
```python
???
```

### Пример работы скрипта:
???