# devops-netology
### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ                                                                                                                                                   |
| ------------- |---------------------------------------------------------------------------------------------------------------------------------------------------------|
| Какое значение будет присвоено переменной `c`?  | Получаем ошибку `TypeError: unsupported operand type(s) for +: 'int' and 'str'`, т.к. операция не выполнится с разными типами операндов (строка и число). |
| Как получить для переменной `c` значение 12?  | c = str(a) + b                                                                                                                                          |
| Как получить для переменной `c` значение 3?  | c = a + int(b)                                                                                                                                                     |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/devops-netology", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~$ ./python2.py
Homework_3.3_OS.md
Homework_3.4_OS.md
README.md
has_been_moved.txt
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import sys

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
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~$ ./python2.py
/home/vagrant/netology/devops-netology/Homework_3.3_OS.md
/home/vagrant/netology/devops-netology/Homework_3.4_OS.md
/home/vagrant/netology/devops-netology/README.md
/home/vagrant/netology/devops-netology/has_been_moved.txt
vagrant@vagrant:~$ ./python2.py netology/netology-python
netology/netology-python/cp-1251.txt
netology/netology-python/main.py
vagrant@vagrant:~$ ./python2.py test_dir
test_dir is not a git repository
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
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
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~$ ./python3.py
drive.google.com - 64.233.165.194
[ERROR] drive.google.com IP mistmatch: 0.0.0.0 64.233.165.194
mail.google.com - 64.233.165.17
[ERROR] mail.google.com IP mistmatch: 0.0.0.0 64.233.165.17
google.com - 74.125.205.138
[ERROR] google.com IP mistmatch: 0.0.0.0 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 64.233.165.17
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 64.233.165.17
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 64.233.165.17
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 64.233.165.17
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 64.233.165.17
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 64.233.165.17
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 64.233.165.17
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 64.233.165.17
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 64.233.165.17
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 64.233.165.17
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 64.233.165.17
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 64.233.165.17
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 64.233.165.17
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 64.233.165.17
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 64.233.165.17
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 64.233.165.17
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 64.233.165.17
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 74.125.205.17
[ERROR] mail.google.com IP mistmatch: 64.233.165.17 74.125.205.17
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 74.125.205.83
[ERROR] mail.google.com IP mistmatch: 74.125.205.17 74.125.205.83
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 74.125.205.83
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 74.125.205.83
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 74.125.205.83
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 74.125.205.83
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 74.125.205.83
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 74.125.205.83
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 74.125.205.83
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 74.125.205.83
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 74.125.205.83
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 74.125.205.83
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 74.125.205.83
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 74.125.205.83
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 74.125.205.83
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 74.125.205.83
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 74.125.205.83
google.com - 74.125.205.138
drive.google.com - 64.233.165.194
mail.google.com - 74.125.205.83
google.com - 74.125.205.138
drive.google.com - 74.125.205.194
[ERROR] drive.google.com IP mistmatch: 64.233.165.194 74.125.205.194
mail.google.com - 74.125.205.83
google.com - 74.125.205.138
drive.google.com - 74.125.205.194
mail.google.com - 74.125.205.83
google.com - 74.125.205.138
drive.google.com - 74.125.205.194
mail.google.com - 74.125.205.83
google.com - 74.125.205.138
drive.google.com - 74.125.205.194
mail.google.com - 74.125.205.83
google.com - 173.194.222.139
[ERROR] google.com IP mistmatch: 74.125.205.138 173.194.222.139
drive.google.com - 74.125.205.194
mail.google.com - 74.125.205.83
google.com - 173.194.222.102
[ERROR] google.com IP mistmatch: 173.194.222.139 173.194.222.102
drive.google.com - 74.125.205.194
mail.google.com - 74.125.205.83
google.com - 173.194.222.102
drive.google.com - 74.125.205.194
mail.google.com - 74.125.205.83
google.com - 173.194.222.102
drive.google.com - 74.125.205.194
mail.google.com - 74.125.205.83
google.com - 173.194.222.102
drive.google.com - 74.125.205.194
mail.google.com - 64.233.163.17
[ERROR] mail.google.com IP mistmatch: 74.125.205.83 64.233.163.17
google.com - 173.194.222.102
drive.google.com - 74.125.205.194
mail.google.com - 64.233.163.83
[ERROR] mail.google.com IP mistmatch: 64.233.163.17 64.233.163.83
google.com - 173.194.222.102
drive.google.com - 74.125.205.194
mail.google.com - 64.233.163.83
google.com - 173.194.222.102
drive.google.com - 74.125.205.194
mail.google.com - 64.233.163.83
google.com - 173.194.222.102
drive.google.com - 74.125.205.194
mail.google.com - 64.233.163.83
google.com - 173.194.222.102
drive.google.com - 74.125.205.194
mail.google.com - 64.233.163.83
google.com - 173.194.222.102
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. С директорией локального репозитория можно делать всё, что угодно. Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 

### Ваш скрипт:
```python
???
```

### Вывод скрипта при запуске при тестировании:
```
???
```