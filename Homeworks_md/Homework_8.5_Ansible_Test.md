# devops-netology
### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию "8.5. Тестирование roles"

## Подготовка к выполнению
1. Установите molecule: `pip3 install "molecule==3.5.2"`
2. Выполните `docker pull aragast/netology:latest` - это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри

### Ответ:
Подготовка выполнена:
```shell
egor@netology:~$ molecule --version
molecule 3.5.2 using python 3.8
    ansible:2.13.7
    delegated:3.5.2 from molecule
egor@netology:~$ docker image ls
REPOSITORY          TAG       IMAGE ID       CREATED         SIZE
aragast/netology    latest    b453a84e3f7a   4 months ago    2.46GB    
```

## Основная часть

Наша основная цель - настроить тестирование наших ролей. Задача: сделать сценарии тестирования для vector. Ожидаемый результат: все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos7` внутри корневой директории clickhouse-role, посмотрите на вывод команды.
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
4. Добавьте несколько assert'ов в verify.yml файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска, etc). Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example)
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo - путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini` для того чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Ссылка на репозиторий являются ответами на домашнее задание. Не забудьте указать в ответе теги решений Tox и Molecule заданий.

### Ответ:
#### Molecule

1. Запустил  `molecule test -s centos7` внутри корневой директории clickhouse-role, роль `git@github.com:AlexeySetevoi/ansible-clickhouse.git` взята из предыдущего задания:
    ```shell
    egor@netology:~/Homeworks/08.5/ansible/roles/clickhouse-role$ molecule test -s centos_7
   INFO     centos_7 scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
   INFO     Performing prerun...
   INFO     Set ANSIBLE_LIBRARY=/home/egor/.cache/ansible-compat/0f592f/modules:/home/egor/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
   INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/egor/.cache/ansible-compat/0f592f/collections:/home/egor/.ansible/collections:/usr/share/ansible/collections
   INFO     Set ANSIBLE_ROLES_PATH=/home/egor/.cache/ansible-compat/0f592f/roles:/home/egor/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
   INFO     Inventory /home/egor/Homeworks/08.5/ansible/roles/clickhouse-role/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/egor/.cache/molecule/clickhouse-role/centos_7/inventory/hosts
   INFO     Inventory /home/egor/Homeworks/08.5/ansible/roles/clickhouse-role/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/egor/.cache/molecule/clickhouse-role/centos_7/inventory/group_vars
   INFO     Inventory /home/egor/Homeworks/08.5/ansible/roles/clickhouse-role/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/egor/.cache/molecule/clickhouse-role/centos_7/inventory/host_vars
   INFO     Running centos_7 > dependency
   INFO     Inventory /home/egor/Homeworks/08.5/ansible/roles/clickhouse-role/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/egor/.cache/molecule/clickhouse-role/centos_7/inventory/hosts
   INFO     Inventory /home/egor/Homeworks/08.5/ansible/roles/clickhouse-role/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/egor/.cache/molecule/clickhouse-role/centos_7/inventory/group_vars
   INFO     Inventory /home/egor/Homeworks/08.5/ansible/roles/clickhouse-role/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/egor/.cache/molecule/clickhouse-role/centos_7/inventory/host_vars
   INFO     Running centos_7 > lint
   COMMAND: yamllint .
   ansible-lint
   flake8
   
   fqcn[action-core]: Use FQCN for builtin module actions (set_fact).
   handlers/main.yml:3 Use `ansible.builtin.set_fact` or `ansible.legacy.set_fact` instead.
   
   schema[meta]: 2.8 is not of type 'string' (warning)
   meta/main.yml:1  Returned errors will not include exact line numbers, but they will mention
   the schema name being used as a tag, like ``schema[playbook]``,
   ``schema[tasks]``.
   
   This rule is not skippable and stops further processing of the file.
   
   If incorrect schema was picked, you might want to either:
   
   This rule is not skippable and stops further processing of the file.
   
   If incorrect schema was picked, you might want to either:
   
   * move the file to standard location, so its file is detected correctly.
     * use ``kinds:`` option in linter config to help it pick correct file type.
   
   You can skip specific rules or tags by adding them to your configuration file:
   # .config/ansible-lint.yml
   warn_list:  # or 'skip_list' to silence them completely
     - experimental  # all rules tagged as experimental
       - fqcn[action-core]  # Use FQCN for builtin actions.
       - name[missing]  # Rule for checking task and play names.
       - name[template]  # Rule for checking task and play names.
   
                                   Rule Violation Summary
    count tag                    profile    rule associated tags
        2 jinja[spacing]         basic      formatting (warning)
        1 schema[inventory]      basic      core, experimental (warning)
        1 schema[meta]           basic      core, experimental (warning)
        9 name[missing]          basic      idiom
        1 name[template]         moderate   idiom
        1 no-free-form           moderate   syntax, risk, experimental (warning)
        1 risky-file-permissions safety     unpredictability, experimental (warning)
       63 fqcn[action-core]      production formatting
   
   Failed after min profile: 73 failure(s), 6 warning(s) on 53 files.
   /bin/bash: line 2: flake8: command not found
   CRITICAL Lint failed with error code 127
   WARNING  An error occurred during the test sequence action: 'lint'. Cleaning up.
   INFO     Inventory /home/egor/Homeworks/08.5/ansible/roles/clickhouse-role/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/egor/.cache/molecule/clickhouse-role/centos_7/inventory/hosts
   INFO     Inventory /home/egor/Homeworks/08.5/ansible/roles/clickhouse-role/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/egor/.cache/molecule/clickhouse-role/centos_7/inventory/group_vars
   INFO     Inventory /home/egor/Homeworks/08.5/ansible/roles/clickhouse-role/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/egor/.cache/molecule/clickhouse-role/centos_7/inventory/host_vars
   INFO     Running centos_7 > cleanup
   WARNING  Skipping, cleanup playbook not configured.
   INFO     Inventory /home/egor/Homeworks/08.5/ansible/roles/clickhouse-role/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/egor/.cache/molecule/clickhouse-role/centos_7/inventory/hosts
   INFO     Inventory /home/egor/Homeworks/08.5/ansible/roles/clickhouse-role/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/egor/.cache/molecule/clickhouse-role/centos_7/inventory/group_vars
   INFO     Inventory /home/egor/Homeworks/08.5/ansible/roles/clickhouse-role/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/egor/.cache/molecule/clickhouse-role/centos_7/inventory/host_vars
   INFO     Running centos_7 > destroy
   INFO     Sanity checks: 'docker'
   
   PLAY [Destroy] *****************************************************************
   
   TASK [Destroy molecule instance(s)] ********************************************
   changed: [localhost] => (item=centos_7)
   
   TASK [Wait for instance(s) deletion to complete] *******************************
   FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
   ok: [localhost] => (item=centos_7)
   
   TASK [Delete docker networks(s)] ***********************************************
   
   PLAY RECAP *********************************************************************
   localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
   
   INFO     Pruning extra files from scenario ephemeral directory
    ```  
2. Запустил в каталоге `vector-role` команду для создания сценария тестирования:
    ```shell
    egor@netology:~/Homeworks/08.5/ansible/roles/vector-role$ molecule init scenario --driver-name docker
    INFO     Initializing new scenario default...
    INFO     Initialized scenario in /home/egor/Homeworks/08.5/ansible/roles/vector-role/molecule/default successfully.
    ```
3. Добавил дистрибутив `ubuntu:latest` и `centos:8`. Запустил `molecule test`:
   ```shell
   egor@netology:~/Homeworks/08.5/ansible/roles/vector-role$ molecule test
   INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
   INFO     Performing prerun...
   INFO     Set ANSIBLE_LIBRARY=/home/egor/.cache/ansible-compat/f5bcd7/modules:/home/egor/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
   INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/egor/.cache/ansible-compat/f5bcd7/collections:/home/egor/.ansible/collections:/usr/share/ansible/collections
   INFO     Set ANSIBLE_ROLES_PATH=/home/egor/.cache/ansible-compat/f5bcd7/roles:/home/egor/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
   INFO     Running default > dependency
   INFO     Running default > lint
   INFO     Lint is disabled.
   INFO     Running default > cleanup
   INFO     Running default > destroy
   INFO     Sanity checks: 'docker'
   
   PLAY [Destroy] *****************************************************************
   
   TASK [Destroy molecule instance(s)] ********************************************
   changed: [localhost] => (item=instance)
   
   TASK [Wait for instance(s) deletion to complete] *******************************
   ok: [localhost] => (item=instance)
   
   TASK [Delete docker networks(s)] ***********************************************
   
   PLAY RECAP *********************************************************************
   localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
   
   INFO     Running default > syntax
   
   playbook: /home/egor/Homeworks/08.5/ansible/roles/vector-role/molecule/default/converge.yml
   INFO     Running default > create
   
   PLAY [Create] ******************************************************************
   
   TASK [Log into a Docker registry] **********************************************
   skipping: [localhost] => (item=None)
   skipping: [localhost]
   
   TASK [Check presence of custom Dockerfiles] ************************************
   ok: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True})
   
   TASK [Create Dockerfiles from image names] *************************************
   skipping: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True})
   
   TASK [Discover local Docker images] ********************************************
   ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
   
   TASK [Build an Ansible compatible image (new)] *********************************
   skipping: [localhost] => (item=molecule_local/quay.io/centos/centos:stream8)
   
   TASK [Create docker network(s)] ************************************************
   
   TASK [Determine the CMD directives] ********************************************
   ok: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True})
   
   TASK [Create molecule instance(s)] *********************************************
   changed: [localhost] => (item=instance)
   
   TASK [Wait for instance(s) creation to complete] *******************************
   FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
   changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '478877206238.27451', 'results_file': '/home/egor/.ansible_async/478877206238.27451', 'changed': True, 'item': {'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
   
   PLAY RECAP *********************************************************************
   localhost                  : ok=5    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0
   ```  
   Запустил тест ubuntu `molecule test ubuntu_latest`:
```shell
egor@netology:~/Homeworks/08.5/ansible/roles/vector-role$ molecule test ubuntu_latest
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/home/egor/.cache/ansible-compat/f5bcd7/modules:/home/egor/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/egor/.cache/ansible-compat/f5bcd7/collections:/home/egor/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/egor/.cache/ansible-compat/f5bcd7/roles:/home/egor/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
ok: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax
WARNING  An error occurred during the test sequence action: 'syntax'. Cleaning up.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
ok: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```  
4. Добавил несколько assert'ов в [verify.yml файл](../practice/08.5/ansible/roles/vector-role/molecule/ubuntu_latest/verify.yml). Запустил проверку:
   ```shell
   egor@netology:~/Homeworks/08.5/ansible/roles/vector-role$ molecule test ubuntu_latest
   INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
   INFO     Performing prerun...
   INFO     Set ANSIBLE_LIBRARY=/home/egor/.cache/ansible-compat/f5bcd7/modules:/home/egor/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
   INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/egor/.cache/ansible-compat/f5bcd7/collections:/home/egor/.ansible/collections:/usr/share/ansible/collections
   INFO     Set ANSIBLE_ROLES_PATH=/home/egor/.cache/ansible-compat/f5bcd7/roles:/home/egor/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
   INFO     Running default > dependency
   WARNING  Skipping, missing the requirements file.
   WARNING  Skipping, missing the requirements file.
   INFO     Running default > lint
   INFO     Lint is disabled.
   INFO     Running default > cleanup
   WARNING  Skipping, cleanup playbook not configured.
   INFO     Running default > destroy
   INFO     Sanity checks: 'docker'
   
   PLAY [Destroy] *****************************************************************
   
   TASK [Destroy molecule instance(s)] ********************************************
   changed: [localhost] => (item=instance)
   
   TASK [Wait for instance(s) deletion to complete] *******************************
   ok: [localhost] => (item=instance)
   
   TASK [Delete docker networks(s)] ***********************************************
   
   PLAY RECAP *********************************************************************
   localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
   
   INFO     Running default > syntax
   INFO     Running default > cleanup
   WARNING  Skipping, cleanup playbook not configured.
   INFO     Running default > destroy
   
   PLAY [Destroy] *****************************************************************
   
   TASK [Destroy molecule instance(s)] ********************************************
   changed: [localhost] => (item=instance)
   
   TASK [Wait for instance(s) deletion to complete] *******************************
   ok: [localhost] => (item=instance)
   
   TASK [Delete docker networks(s)] ***********************************************
   
   PLAY RECAP *********************************************************************
   localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
   
   INFO     Pruning extra files from scenario ephemeral directory
   ```  
5. [Ссылка на репозиторий vector-role с тестами molecule](https://github.com/E-zh/vector-role/tree/1.0.1).


#### Tox

1. Добавил в директорию с vector-role файлы из [директории](https://github.com/netology-code/mnt-homeworks/blob/MNT-video/08-ansible-05-testing/example).
2. Запустил команду `docker run --privileged=True -v ~/Homeworks/08.5/ansible/roles/vector-role:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, попал внутрь контейнера.
3. Вывод команды очень большой, выполнялась долго.
4. Прописал команду в [файле tox.ini](../practice/08.5/ansible/roles/vector-role/tox.ini).
5. Запустил `tox`, отработал быстрее.
6. [Ссылка на репозиторий vector-role с тестами molecule и tox](https://github.com/E-zh/vector-role/tree/1.0.2).
