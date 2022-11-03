# devops-netology
### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами".

### Задача 1.
* Опишите своими словами основные преимущества применения на практике IaaC паттернов.

#### Ответ:
Основополагающим принципом, в рамках IaaC, является обеспечение идемпотентности. В данном случае это можно понимать, как более быстрое развертывание среды инфраструктуры у всех участников, и все настройки и установленное ПО, в т.ч. версии, будут одинаковы у всех. Такой момент, что у кого-либо из сотрудников что-то отличается, и поэтому не работает, в данном случае исключается.

* Какой из принципов IaaC является основополагающим?

#### Ответ:
Основополагающий принцип IaaC - каждый раз разворачивая инфрастуктуру с помощью кода, мы получим абсолютно идентичный результат независимо от количества участников.

### Задача 2.
* Чем Ansible выгодно отличается от других систем управление конфигурациями?

#### Ответ:
Ansible написан на Python и использует метод push, что не требует установки ни агентов, ни каких-либо демонов, как в случае с методом pull,
которому для работы требуются такие агенты. Теоретически, требование агентов потенциально может быть узким местом, т.е. потенциальной точкой сбоя.
Также Ansible использует SSH. Все вышесказанное, по моему мнению, делает Ansible более простым и эффективным.

* Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

#### Ответ:
По моему мнению, метод pull является более надежным, потому что в данном случае сервер сам запрашивает конфигурацию после его развертывания.

### Задача 3.
Установить на личный компьютер:
* VirtualBox
* Vagrant
* Ansible

#### Ответ:
* Установил Virtualbox:
```shell
egor@netology:~$ vboxmanage --version
6.1.38_Ubuntur153438
```
* Установил Vagrant (ввиду ограничений, не получилось установить версию 2.3.2, поэтому был скачан последний доступный пакет .deb):
```shell
egor@netology:~$ vagrant --version
Vagrant 2.2.19
```
* Установил Ansible:
```shell
egor@netology:~$ ansible --version
ansible 2.9.6
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/egor/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Jun 22 2022, 20:18:18) [GCC 9.4.0]
```

### Задача 4.
Воспроизвести практическую часть лекции самостоятельно:
* Создать виртуальную машину.
* Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды `docker ps`.

#### Ответ:
```shell
egor@netology:~/server/ansible$ vagrant up
Bringing machine 'server1.netology' up with 'virtualbox' provider...
==> server1.netology: Importing base box 'bento/ubuntu-20.04'...
==> server1.netology: Matching MAC address for NAT networking...
==> server1.netology: Checking if box 'bento/ubuntu-20.04' version '202206.03.0' is up to date...
==> server1.netology: Setting the name of the VM: server1.netology
==> server1.netology: Clearing any previously set network interfaces...
==> server1.netology: Preparing network interfaces based on configuration...
    server1.netology: Adapter 1: nat
    server1.netology: Adapter 2: hostonly
==> server1.netology: Forwarding ports...
    server1.netology: 22 (guest) => 20011 (host) (adapter 1)
    server1.netology: 22 (guest) => 2222 (host) (adapter 1)
==> server1.netology: Running 'pre-boot' VM customizations...
==> server1.netology: Booting VM...
==> server1.netology: Waiting for machine to boot. This may take a few minutes...
    server1.netology: SSH address: 127.0.0.1:2222
    server1.netology: SSH username: vagrant
    server1.netology: SSH auth method: private key
    server1.netology: Warning: Connection reset. Retrying...
    server1.netology: Warning: Remote connection disconnect. Retrying...
    server1.netology:
    server1.netology: Vagrant insecure key detected. Vagrant will automatically replace
    server1.netology: this with a newly generated keypair for better security.
    server1.netology:
    server1.netology: Inserting generated public key within guest...
    server1.netology: Removing insecure key from the guest if it's present...
    server1.netology: Key inserted! Disconnecting and reconnecting using new SSH key...
==> server1.netology: Machine booted and ready!
==> server1.netology: Checking for guest additions in VM...
==> server1.netology: Setting hostname...
==> server1.netology: Configuring and enabling network interfaces...
==> server1.netology: Mounting shared folders...
    server1.netology: /vagrant => /home/egor/server/ansible
==> server1.netology: Running provisioner: ansible...
    server1.netology: Running ansible-playbook...

PLAY [Playbook] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [server1.netology]

TASK [Installing tools] ********************************************************
ok: [server1.netology] => (item=['git', 'curl'])

TASK [Installing docker] *******************************************************
changed: [server1.netology]

TASK [Add the current user to docker group] ************************************
changed: [server1.netology]

PLAY RECAP *********************************************************************
server1.netology           : ok=4    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

egor@netology:~/server/ansible$ vagrant ssh
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-110-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Thu 03 Nov 2022 10:11:40 AM UTC

  System load:  0.08               Users logged in:          0
  Usage of /:   13.6% of 30.63GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 23%                IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1:    192.168.56.11
  Processes:    110


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Thu Nov  3 09:04:23 2022 from 10.0.2.2
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```