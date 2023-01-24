# devops-netology
### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию "8.1. Введение в Ansible."

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

### Ответ:
1. Установлен ansible версии `2.13.7`.
2. Задания буду хранить в существующем репозитории.
3. Скачал и перенес `playbook` в свой репозиторий.

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
6. Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

### Ответ:
1. Запустил playbook на окружении из `test.yml`, факт имеет значение `12`:
    ```shell
    egor@netology1:~/Homework/08.1/playbook$ ansible-playbook site.yml -i inventory/test.yml
    
    PLAY [Print os facts] ****************************************************************************************************
    
    TASK [Gathering Facts] ***************************************************************************************************
    ok: [localhost]
    
    TASK [Print OS] **********************************************************************************************************
    ok: [localhost] => {
        "msg": "Ubuntu"
    }
    
    TASK [Print fact] ********************************************************************************************************
    ok: [localhost] => {
        "msg": 12
    }
    
    PLAY RECAP ***************************************************************************************************************
    localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```
2. Нашел файл, с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменял его на `all default fact`:
   ```shell
   egor@netology1:~/Homework/08.1/playbook$ cat  group_vars/all/examp.yml
   ---
     some_fact: "all default fact"
   ```
3. На сервере установлен docker, его и буду использовать далее.
4. Запустил playbook на окружении из `prod.yml`:
   ```shell
   egor@netology1:~/playbook$ ansible-playbook -i inventory/prod.yml site.yml
   
   PLAY [Print os facts] *************************************************************************************************
   
   TASK [Gathering Facts] ************************************************************************************************
   ok: [ubuntu]
   ok: [centos7]
   
   TASK [Print OS] *******************************************************************************************************
   ok: [centos7] => {
       "msg": "CentOS"
   }
   ok: [ubuntu] => {
       "msg": "Ubuntu"
   }
   
   TASK [Print fact] *****************************************************************************************************
   ok: [centos7] => {
       "msg": "el"
   }
   ok: [ubuntu] => {
       "msg": "deb"
   }
   
   PLAY RECAP ************************************************************************************************************
   centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   ```
5. Внес изменения в файлы `group_vars` каждой из групп хостов:
   ```shell
   egor@netology1:~/playbook$ cat group_vars/deb/examp.yml
   ---
     some_fact: "deb default fact"
   egor@netology1:~/playbook$ cat group_vars/el/examp.yml
   ---
     some_fact: "el default fact"
   ```
6. Повторил запуск playbook на окружении `prod.yml`:
   ```shell
   egor@netology1:~/playbook$ ansible-playbook -i inventory/prod.yml site.yml
   
   PLAY [Print os facts] *************************************************************************************************
   
   TASK [Gathering Facts] ************************************************************************************************
   ok: [ubuntu]
   ok: [centos7]
   
   TASK [Print OS] *******************************************************************************************************
   ok: [centos7] => {
       "msg": "CentOS"
   }
   ok: [ubuntu] => {
       "msg": "Ubuntu"
   }
   
   TASK [Print fact] *****************************************************************************************************
   ok: [centos7] => {
       "msg": "el default fact"
   }
   ok: [ubuntu] => {
       "msg": "deb default fact"
   }
   
   PLAY RECAP ************************************************************************************************************
   centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   ```
7. Зашифровал факты в `group_vars/deb` и `group_vars/el` с паролем `netology`:
   ```shell
   egor@netology1:~/playbook$ ansible-vault encrypt group_vars/deb/examp.yml
   New Vault password:
   Confirm New Vault password:
   Encryption successful
   egor@netology1:~/playbook$ ansible-vault encrypt group_vars/el/examp.yml
   New Vault password:
   Confirm New Vault password:
   Encryption successful
   ```
8. Запустил playbook на окружении `prod.yml`. При запуске `ansible` запросил пароль:
   ```shell
   egor@netology1:~/playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
   Vault password:
   
   PLAY [Print os facts] *************************************************************************************************
   
   TASK [Gathering Facts] ************************************************************************************************
   ok: [ubuntu]
   ok: [centos7]
   
   TASK [Print OS] *******************************************************************************************************
   ok: [centos7] => {
       "msg": "CentOS"
   }
   ok: [ubuntu] => {
       "msg": "Ubuntu"
   }
   
   TASK [Print fact] *****************************************************************************************************
   ok: [centos7] => {
       "msg": "el default fact"
   }
   ok: [ubuntu] => {
       "msg": "deb default fact"
   }
   
   PLAY RECAP ************************************************************************************************************
   centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   ```
9. Посмотрел при помощи `ansible-doc` список плагинов для подключения. Выбрал подходящий - `local`:
   ```shell
   egor@netology1:~/playbook$ ansible-doc -t connection -l
   ansible.netcommon.grpc         Provides a persistent connection using the gRPC protocol
   ansible.netcommon.httpapi      Use httpapi to run command on network appliances
   ansible.netcommon.libssh       Run tasks using libssh for ssh connection
   ansible.netcommon.napalm       Provides persistent connection using NAPALM
   ansible.netcommon.netconf      Provides a persistent connection using the netconf protocol
   ansible.netcommon.network_cli  Use network_cli to run command on network appliances
   ansible.netcommon.persistent   Use a persistent unix socket for connection
   community.aws.aws_ssm          execute via AWS Systems Manager
   community.docker.docker        Run tasks in docker containers
   community.docker.docker_api    Run tasks in docker containers
   community.docker.nsenter       execute on host running controller container
   community.general.chroot       Interact with local chroot
   community.general.funcd        Use funcd to connect to target
   community.general.iocage       Run tasks in iocage jails
   community.general.jail         Run tasks in jails
   community.general.lxc          Run tasks in lxc containers via lxc python library
   community.general.lxd          Run tasks in lxc containers via lxc CLI
   community.general.qubes        Interact with an existing QubesOS AppVM
   community.general.saltstack    Allow ansible to piggyback on salt minions
   community.general.zone         Run tasks in a zone instance
   community.libvirt.libvirt_lxc  Run tasks in lxc containers via libvirt
   community.libvirt.libvirt_qemu Run tasks on libvirt/qemu virtual machines
   community.okd.oc               Execute tasks in pods running on OpenShift
   community.vmware.vmware_tools  Execute tasks inside a VM via VMware Tools
   containers.podman.buildah      Interact with an existing buildah container
   containers.podman.podman       Interact with an existing podman container
   kubernetes.core.kubectl        Execute tasks in pods running on Kubernetes
   local                          execute on controller
   paramiko_ssh                   Run tasks via python ssh (paramiko)
   psrp                           Run tasks over Microsoft PowerShell Remoting Protocol
   ssh                            connect via SSH client binary
   winrm                          Run tasks over Microsoft's WinRM
   ```
10. В `prod.yml` добавил новую группу хостов с именем `local`:
   ```yaml
     el:
       hosts:
         centos7:
           ansible_connection: docker
     deb:
       hosts:
         ubuntu:
           ansible_connection: docker
     local:
       hosts:
         localhost:
           ansible_host: localhost
           ansible_connection: local
   ```
11. Запустил playbook на окружении `prod.yml`. При запуске `ansible` запросил пароль, факты `some_fact` для каждого из хостов определены из верных `group_vars`:
   ```shell
   egor@netology1:~/playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
   Vault password:
   
   PLAY [Print os facts] *************************************************************************************************
   
   TASK [Gathering Facts] ************************************************************************************************
   ok: [localhost]
   ok: [ubuntu]
   ok: [centos7]
   
   TASK [Print OS] *******************************************************************************************************
   ok: [centos7] => {
       "msg": "CentOS"
   }
   ok: [ubuntu] => {
       "msg": "Ubuntu"
   }
   ok: [localhost] => {
       "msg": "Ubuntu"
   }
   
   TASK [Print fact] *****************************************************************************************************
   ok: [centos7] => {
       "msg": "el default fact"
   }
   ok: [localhost] => {
       "msg": "all default fact"
   }
   ok: [ubuntu] => {
       "msg": "deb default fact"
   }
   
   PLAY RECAP ************************************************************************************************************
   centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   ```
12. Заполненный файл [READ.ME находится здесь](/practice/08.1/playbook/README.md), измененные файлы [находятся здесь](/practice/08.1/playbook).

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

### Ответ:

1. Расшифровал все файлы:
   ```shell
   egor@netology1:~/playbook$ ansible-vault decrypt group_vars/deb/examp.yml group_vars/el/examp.yml
   Vault password:
   Decryption successful
   ```
2. Зашифровал отдельное значение и добавил в `group_vars/all/exmp.yml`:
   ```shell
   egor@netology1:~/playbook$ ansible-vault encrypt_string "PaSSw0rd"
   New Vault password:
   Confirm New Vault password:
   Encryption successful
   !vault |
             $ANSIBLE_VAULT;1.1;AES256
             65373435633131383635373930373735356435383935363038366233353530323161333337363262
             3737653830323432346662636532643233346464646235350a613762343763393831373539323465
             31323037633038653437316538396232636565353462343936663065333663376366666239646461
             3638373539343830360a383665666161363737353632383734353533393062393062626164303930
             6437
   ```
3. Запустил playbook, увидел новый fact:
   ```shell
   egor@netology1:~/playbook$ ansible-playbook -i inventory/test.yml site.yml --ask-vault-pass
   Vault password:
   
   PLAY [Print os facts] *************************************************************************************************
   
   TASK [Gathering Facts] ************************************************************************************************
   ok: [localhost]
   
   TASK [Print OS] *******************************************************************************************************
   ok: [localhost] => {
       "msg": "Ubuntu"
   }
   
   TASK [Print fact] *****************************************************************************************************
   ok: [localhost] => {
       "msg": "PaSSw0rd"
   }
   
   PLAY RECAP ************************************************************************************************************
   localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   ```
4. Добавил новую группу хостов `fedora`:
   ```yaml
     el:
       hosts:
         centos7:
           ansible_connection: docker
     deb:
       hosts:
         ubuntu:
           ansible_connection: docker
     local:
       hosts:
         localhost:
           ansible_host: localhost
           ansible_connection: local
     fed:
       hosts:
         fedora:
           ansible_connection: docker
   ```  
   Запустил playbook:
   ```shell
   egor@netology1:~/playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
   Vault password:
   
   PLAY [Print os facts] *************************************************************************************************
   
   TASK [Gathering Facts] ************************************************************************************************
   ok: [localhost]
   ok: [fedora]
   ok: [ubuntu]
   ok: [centos7]
   
   TASK [Print OS] *******************************************************************************************************
   ok: [centos7] => {
       "msg": "CentOS"
   }
   ok: [ubuntu] => {
       "msg": "Ubuntu"
   }
   ok: [localhost] => {
       "msg": "Ubuntu"
   }
   ok: [fedora] => {
       "msg": "Fedora"
   }
   
   TASK [Print fact] *****************************************************************************************************
   ok: [centos7] => {
       "msg": "el default fact"
   }
   ok: [fedora] => {
       "msg": "fed default fact"
   }
   ok: [ubuntu] => {
       "msg": "deb default fact"
   }
   ok: [localhost] => {
       "msg": "PaSSw0rd"
   }
   
   PLAY RECAP ************************************************************************************************************
   centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   ```
5. Скрипт для автоматического запуска и остановки через 30 секунд:
   ```shell
   #!/usr/local/env bash

   docker run -dit --name centos7 pycontribs/centos:7 sleep 6000000
   docker run -dit --name ubuntu pycontribs/ubuntu:latest sleep 6000000
   docker run -dit --name fedora pycontribs/fedora:latest sleep 6000000
   
   ansible-playbook -i inventory/prod.yml site.yml --vault-password-file password.txt
   
   sleep 30
   
   echo "Stop and removing containers..."
   
   docker stop centos7 && docker rm centos7
   docker stop ubuntu && docker rm ubuntu
   docker stop fedora && docker rm fedora
   ```
   Скрипт работает. Конечно практичнее сделать с помощью `docker-compose`, попробую усовершенствовать позже. Результат выполнения:
   ```shell
   egor@netology1:~/playbook$ docker ps -a
   CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
   egor@netology1:~/playbook$ bash ansible.sh
   1a16fcbc801e68d892437b12de36bd51de408d3fe9ea800374a674fa98ff3891
   596ab3c8971d83fd61521fc5e7a565972e2b08bf410c0d992a5b9588c9bb207f
   2ba2f4b2d60f036ac5441ce5c89942d7d422eb63888c78fa4e0e6efcb74ee613
   
   PLAY [Print os facts] ****************************************************************************************************************************************************************
   
   TASK [Gathering Facts] ***************************************************************************************************************************************************************
   ok: [localhost]
   ok: [fedora]
   ok: [ubuntu]
   ok: [centos7]
   
   TASK [Print OS] **********************************************************************************************************************************************************************
   ok: [centos7] => {
       "msg": "CentOS"
   }
   ok: [ubuntu] => {
       "msg": "Ubuntu"
   }
   ok: [localhost] => {
       "msg": "Ubuntu"
   }
   ok: [fedora] => {
       "msg": "Fedora"
   }
   
   TASK [Print fact] ********************************************************************************************************************************************************************
   ok: [centos7] => {
       "msg": "el default fact"
   }
   ok: [ubuntu] => {
       "msg": "deb default fact"
   }
   ok: [fedora] => {
       "msg": "fed default fact"
   }
   ok: [localhost] => {
       "msg": "PaSSw0rd"
   }
   
   PLAY RECAP ***************************************************************************************************************************************************************************
   centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   
   Stop and removing containers...
   centos7
   centos7
   ubuntu
   ubuntu
   fedora
   fedora
   egor@netology1:~/playbook$
   ```