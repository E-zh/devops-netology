# devops-netology

### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию 13.3 «Как работает сеть в K8s»

### Цель задания

Настроить сетевую политику доступа к подам.

### Чеклист готовности к домашнему заданию

1. Кластер K8s с установленным сетевым плагином Calico.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Calico](https://www.tigera.io/project-calico/).
2. [Network Policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/).
3. [About Network Policy](https://docs.projectcalico.org/about/about-network-policy).

-----

### Задание 1. Создать сетевую политику или несколько политик для обеспечения доступа

1. Создать deployment'ы приложений frontend, backend и cache и соответсвующие сервисы.
2. В качестве образа использовать network-multitool.
3. Разместить поды в namespace App.
4. Создать политики, чтобы обеспечить доступ frontend -> backend -> cache. Другие виды подключений должны быть запрещены.
5. Продемонстрировать, что трафик разрешён и запрещён.

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

### Ответ:
1. Создал deployment'ы приложений frontend, backend и cache и соответсвующие сервисы:
    * [Frontend](/practice/13.3/deployment_frontend.yaml)
    * [Backend](/practice/13.3/deployment_backend.yaml)
    * [Cache](/practice/13.3/deployment_cache.yaml)
2. В качестве образа использовал network-multitool: `image: praqma/network-multitool:alpine-extra`.
3. Разместил поды в namespace `app`.
4. Создал политики, чтобы обеспечить доступ `frontend -> backend -> cache`. Другие виды подключений запрещены:
    * [Network Policy Default](/practice/13.3/network_policy_default.yaml)
    * [Network Policy Frontend](/practice/13.3/network_policy_frontend.yaml)
    * [Network Policy Backend](/practice/13.3/network_policy_backend.yaml)
    * [Network Policy Cache](/practice/13.3/network_policy_cache.yaml)
5. Ниже демонстрация, что все работает:
    * запустил все три deployment в namespace app:  
    ![](/pics/13.3/running_deployments.jpg)  
    * видим что поды беспроблемно могут ходить друг к другу (политики пока не применены):  
    ![](/pics/13.3/allow_all.jpg)  
    * применяем политики, и видим что поду могут ходить только в соответствии с правилом `frontend -> backend -> cache`:  
    * frontend может ходить в backend (10.152.183.103), но не может ходить в cache (10.152.183.235):   
    ![](/pics/13.3/frontend_rule.jpg)  
    * backend может ходить в cache (10.152.183.235), но не может ходить во frontend (10.152.183.193):  
    ![](/pics/13.3/backend_rule.jpg)  
    * cache не может ходить ни во frontend (10.152.183.193), ни в backend (10.152.183.103):  
    ![](/pics/13.3/cache_rule.jpg)  
6. По последним двум правилам выжидал более 30 секунд и завршал по нажатию `Ctrl+C`, иначе очень долго ждать вывода сообщения о невозможности подключиться.
7. На этом выполнение задания завершено.
