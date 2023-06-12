# devops-netology

### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию 12.2 «Базовые объекты K8S»

### Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Pod с приложением и подключиться к нему со своего локального компьютера. 

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Описание [Pod](https://kubernetes.io/docs/concepts/workloads/pods/) и примеры манифестов.
2. Описание [Service](https://kubernetes.io/docs/concepts/services-networking/service/).

------

### Задание 1. Создать Pod с именем hello-world

1. Создать манифест (yaml-конфигурацию) Pod.
2. Использовать image - gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Подключиться локально к Pod с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

### Ответ:

1. Создал [манифест hello-world.yaml](/practice/12.2/hello-world.yaml)
2. Использовал в нем вышеуказанный image
3. Подключился к Pod с помощью `kubectl port-forward pod/hello-world 8000:8080 --address='192.168.1.74'`:
    * с помощью curl:  
    ![](/pics/12.2/hello-world-curl.jpg)  
    * и через браузер:  
    ![](/pics/12.2/hello-world-browser.jpg)  
------

### Задание 2. Создать Service и подключить его к Pod

1. Создать Pod с именем netology-web.
2. Использовать image — gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Создать Service с именем netology-svc и подключить к netology-web.
4. Подключиться локально к Service с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

### Ответ:

1. Создал [Pod и Service в одном манифесте](/practice/12.2/netology-web.yaml)
2. Использовал в нем вышеуказанный image
3. И service и pod созданы в одном файле, запускаем `kubectl apply -f netology-web.yaml`:  
    ![](/pics/12.2/create_pod_service.jpg)  
4. Подключился к Service с помощью `kubectl port-forward scv/netology-web 3000:8001 --address='192.168.1.74'`:  
    * с помощью curl:  
    ![](/pics/12.2/netology-web-curl.jpg)  
    * с помощью браузера:  
    ![](/pics/12.2/netology-web-browser.jpg)  
    * в консоли видно что подключения осуществились на порт 3000:  
    ![](/pics/12.2/service_listen_port_3000.jpg)  
