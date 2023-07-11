# devops-netology

### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию 12.7 «Хранение в K8s. Часть 2»

### Цель задания

В тестовой среде Kubernetes нужно создать PV и продемострировать запись и хранение файлов.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным GitHub-репозиторием.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке NFS в MicroK8S](https://microk8s.io/docs/nfs). 
2. [Описание Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/). 
3. [Описание динамического провижининга](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/). 
4. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1

**Что нужно сделать**

Создать Deployment приложения, использующего локальный PV, созданный вручную.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Создать PV и PVC для подключения папки на локальной ноде, которая будет использована в поде.
3. Продемонстрировать, что multitool может читать файл, в который busybox пишет каждые пять секунд в общей директории. 
4. Удалить Deployment и PVC. Продемонстрировать, что после этого произошло с PV. Пояснить, почему.
5. Продемонстрировать, что файл сохранился на локальном диске ноды. Удалить PV.  Продемонстрировать что произошло с файлом после удаления PV. Пояснить, почему.
5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

### Ответ:
1. Создал [Deployment](/practice/12.7/task1/deployment-pv-pvc.yaml) приложения, состоящего из контейнеров busybox и multitool.
2. создал [PV](/practice/12.7/task1/pv-netology.yaml) и [PVC](/practice/12.7/task1/pvc-netology.yaml) для подключения папки на локальной ноде, которая будет использована в поде.
3. Busybox пишет каждые пять секунд в файл, что реализовано строкой `ommand: ['sh', '-c', 'watch -n 5 echo Netology! > /output/netology-file.txt']`.
4. Привожу наглядно:
    * скриншоты работающих подов, deployment, pv и pvc:  
    ![](/pics/12.7/task1-all.jpg)  
    * заходим в контейнер `busybox` командой `kubectl exec -it dep-vol-84686b45ff-95fsl -c=busybox sh`, и далее просмотрим файл `netology-file.txt`, убедимся что в него пишутся данные каждые 5 секунд:  
    ![](/pics/12.7/task1-busybox-write-5sec.jpg)  
    * теперь зайдем в контейнер `multitool` командой `kubectl exec -it dep-vol-84686b45ff-95fsl -c=multitool sh` и прочитаем файл `netology-file.txt`:  
    ![](/pics/12.7/task1-multitool-read-file.jpg)  
5. Удаляем Deployment и PVC, видим что PV остался:  
    ![](/pics/12.7/task1-del-dep-pvc.jpg)  
6. Видим что файл сохранился на локальном диске ноды:  
    ![](/pics/12.7/task1-pv-file.jpg)  
7. Удалил PV. Так как я не указывал в манифесте `ReclaimPolicy`, microk8s автоматически присвоил ему параметр `Delete`, который означает, что после удаления PV ресурсы из внешних провайдеров автоматически удаляются (работает только в облачных Storage), а в нашем случае локальный файл не является облачным хранилищем, поэтому он остался:  
    ![](/pics/12.7/task1-del-pv.jpg)  
------

### Задание 2

**Что нужно сделать**

Создать Deployment приложения, которое может хранить файлы на NFS с динамическим созданием PV.

1. Включить и настроить NFS-сервер на MicroK8S.
2. Создать Deployment приложения состоящего из multitool, и подключить к нему PV, созданный автоматически на сервере NFS.
3. Продемонстрировать возможность чтения и записи файла изнутри пода. 
4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.