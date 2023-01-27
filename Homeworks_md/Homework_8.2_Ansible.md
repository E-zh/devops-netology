# devops-netology
### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию "8.2. Работа с Playbook".

## Подготовка к выполнению

1. (Необязательно) Изучите, что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [vector](https://www.youtube.com/watch?v=CgEhyffisLY)
2. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](https://github.com/netology-code/mnt-homeworks/blob/MNT-video/08-ansible-02-playbook/playbook) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

### Ответ:
Все вышеуказанные действия выполнил, в качестве хостов подняты 2 виртуальные машины с ОС centos 7.

## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.


### Ответ:
1. Подготовлен свой собственный inventory файл [prod.yml](/practice/08.2/playbook/inventory/prod.yml):
    ```yaml
    ---
      clickhouse:
        hosts:
          clickhouse-01:
            ansible_host: 192.168.1.72
            ansible_user: egor
      vector:
        hosts:
          vector-01:
            ansible_host: 192.168.1.73
            ansible_user: egor
    ```  
2. Дописал playbook, привожу фрагмент с дописанным play, устанавливающим vector:
    ```yaml
    - name: Install Vector
      hosts: vector
      handlers:
        - name: Start vector service
          become: true
          ansible.builtin.service:
            name: vector
            state: restarted
      tasks:
        - name: Get vector distrib
          ansible.builtin.get_url:
            url: https://packages.timber.io/vector/{{ vector_version }}/vector-{{ vector_version }}-1.x86_64.rpm
            dest: ./vector-{{ vector_version }}-1.x86_64.rpm
            mode: 0755
        - name: Install vector rpm
          become: true
          ansible.builtin.yum:
            name: vector-{{ vector_version }}-1.x86_64.rpm
            disable_gpg_check: true
          notify: Start vector service
    ```  
3. Из рекомендованных модулей использовал модуль `get_url`.
4. Tasks выполняет необходимые действия.
5. Запустил `ansible-lint site.yml`, ошибок нет, поскольку в процессе выполнения пришлось неоднократно запускать проверки и устранять ошибки.
6. Запустил команду `ansible-playbook -i inventory/prod.yml site.yml --check`:
    ```shell
    [egor@centos-1 playbook]$ ansible-playbook -i inventory/prod.yml site.yml --check
    
    PLAY [Install Clickhouse] ********************************************************************************************************************************
    
    TASK [Gathering Facts] ***********************************************************************************************************************************
    ok: [clickhouse-01]
    
    TASK [Get clickhouse distrib] ****************************************************************************************************************************
    ok: [clickhouse-01] => (item=clickhouse-client)
    ok: [clickhouse-01] => (item=clickhouse-server)
    ok: [clickhouse-01] => (item=clickhouse-common-static)
    
    TASK [Install clickhouse packages] ***********************************************************************************************************************
    ok: [clickhouse-01]
    
    TASK [Create database] ***********************************************************************************************************************************
    skipping: [clickhouse-01]
    
    PLAY [Install Vector] ************************************************************************************************************************************
    
    TASK [Gathering Facts] ***********************************************************************************************************************************
    ok: [vector-01]
    
    TASK [Get vector distrib] ********************************************************************************************************************************
    ok: [vector-01]
    
    TASK [Install vector rpm] ********************************************************************************************************************************
    ok: [vector-01]
    
    PLAY RECAP ***********************************************************************************************************************************************
    clickhouse-01              : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
    vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```  
7. Запустил команду `ansible-playbook -i inventory/prod.yml site.yml --diff`:
    ```shell
    [egor@centos-1 playbook]$ ansible-playbook -i inventory/prod.yml site.yml --diff
    
    PLAY [Install Clickhouse] ********************************************************************************************************************************
    
    TASK [Gathering Facts] ***********************************************************************************************************************************
    ok: [clickhouse-01]
    
    TASK [Get clickhouse distrib] ****************************************************************************************************************************
    ok: [clickhouse-01] => (item=clickhouse-client)
    ok: [clickhouse-01] => (item=clickhouse-server)
    ok: [clickhouse-01] => (item=clickhouse-common-static)
    
    TASK [Install clickhouse packages] ***********************************************************************************************************************
    ok: [clickhouse-01]
    
    TASK [Create database] ***********************************************************************************************************************************
    changed: [clickhouse-01]
    
    PLAY [Install Vector] ************************************************************************************************************************************
    
    TASK [Gathering Facts] ***********************************************************************************************************************************
    ok: [vector-01]
    
    TASK [Get vector distrib] ********************************************************************************************************************************
    ok: [vector-01]
    
    TASK [Install vector rpm] ********************************************************************************************************************************
    ok: [vector-01]
    
    PLAY RECAP ***********************************************************************************************************************************************
    clickhouse-01              : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```  
8. Повторно запустил команду `ansible-playbook -i inventory/prod.yml site.yml --diff`, видим что playbook идемпотентен:
    ```shell
    [egor@centos-1 playbook]$ ansible-playbook -i inventory/prod.yml site.yml --diff
    
    PLAY [Install Clickhouse] ********************************************************************************************************************************
    
    TASK [Gathering Facts] ***********************************************************************************************************************************
    ok: [clickhouse-01]
    
    TASK [Get clickhouse distrib] ****************************************************************************************************************************
    ok: [clickhouse-01] => (item=clickhouse-client)
    ok: [clickhouse-01] => (item=clickhouse-server)
    ok: [clickhouse-01] => (item=clickhouse-common-static)
    
    TASK [Install clickhouse packages] ***********************************************************************************************************************
    ok: [clickhouse-01]
    
    TASK [Create database] ***********************************************************************************************************************************
    ok: [clickhouse-01]
    
    PLAY [Install Vector] ************************************************************************************************************************************
    
    TASK [Gathering Facts] ***********************************************************************************************************************************
    ok: [vector-01]
    
    TASK [Get vector distrib] ********************************************************************************************************************************
    ok: [vector-01]
    
    TASK [Install vector rpm] ********************************************************************************************************************************
    ok: [vector-01]
    
    PLAY RECAP ***********************************************************************************************************************************************
    clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```  
9. По playbook подготовил файл [READ.ME](https://github.com/E-zh/devops-netology-08/blob/main/08.2/playbook/README.md).
10. Ссылку на [репозиторий](https://github.com/E-zh/devops-netology-08) прилагаю.