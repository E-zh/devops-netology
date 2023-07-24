# devops-netology

### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию 12.9 «Управление доступом»

### Цель задания

В тестовой среде Kubernetes нужно предоставить ограниченный доступ пользователю.

------

### Чеклист готовности к домашнему заданию

1. Установлено k8s-решение, например MicroK8S.
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым github-репозиторием.

------

### Инструменты / дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) RBAC.
2. [Пользователи и авторизация RBAC в Kubernetes](https://habr.com/ru/company/flant/blog/470503/).
3. [RBAC with Kubernetes in Minikube](https://medium.com/@HoussemDellai/rbac-with-kubernetes-in-minikube-4deed658ea7b).

------

### Задание 1. Создайте конфигурацию для подключения пользователя

1. Создайте и подпишите SSL-сертификат для подключения к кластеру.
2. Настройте конфигурационный файл kubectl для подключения.
3. Создайте роли и все необходимые настройки для пользователя.
4. Предусмотрите права пользователя. Пользователь может просматривать логи подов и их конфигурацию (`kubectl logs pod <pod_id>`, `kubectl describe pod <pod_id>`).
5. Предоставьте манифесты и скриншоты и/или вывод необходимых команд.

------

### Ответ:

1. Создал и подписал сертификат для подключения к кластеру:
    * создал пользователя `ivan`:  
   ```shell
   egor@netology:~$ sudo adduser ivan
   Adding user `ivan' ...
   Adding new group `ivan' (1002) ...
   Adding new user `ivan' (1001) with group `ivan' ...
   Creating home directory `/home/ivan' ...
   Copying files from `/etc/skel' ...
   New password:
   Retype new password:
   passwd: password updated successfully
   Changing the user information for ivan
   Enter the new value, or press ENTER for the default
           Full Name []:
           Room Number []:
           Work Phone []:
           Home Phone []:
           Other []:
   Is the information correct? [Y/n] y
   ```
   * создал закрытый ключ:  
   ```shell
   root@netology:/home/ivan# openssl genrsa -out ivan.key 2048
   Generating RSA private key, 2048 bit long modulus (2 primes)
   .............................................+++++
   ......................+++++
   e is 65537 (0x010001)
   ```
   * создал запрос на подпись сертификата:  
   ```shell
   root@netology:/home/ivan# openssl req -new -key ivan.key \
   > -out ivan.csr \
   > -subj "/CN=ivan"
   ```
   * подписал CSR сертификатом `microk8s`:  
   ```shell
   root@netology:/home/ivan# openssl x509 -req -in ivan.csr \
   > -CA /var/snap/microk8s/current/certs/ca.crt \
   > -CAkey /var/snap/microk8s/current/certs/ca.key \
   > -CAcreateserial \
   > -out ivan.crt -days 500
   Signature ok
   subject=CN = ivan
   Getting CA Private Key
   ```
   * переместил все созданные файлы в папку `.certs`:  
   ![](/pics/12.9/show_certs.jpg)  
2. Настроил конфигурационный файл (значение сертификата обрезано `nano`):  
   ```yaml
   apiVersion: v1
   clusters:
   - cluster:
       certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUREekNDQWZlZ0F3SUJBZ0lVRER3M2orbmNvUHNFRE5xM0JyYzg5WFZVQ05rd0RRWUpLb1pJaHZjTkFRR>
       server: https://127.0.0.1:16443
     name: microk8s-cluster
   contexts:
     - context:
         cluster: kubernetes
         user: ivan
       name: ivan-context
     - context:
         cluster: microk8s-cluster
         user: admin
       name: microk8s
     current-context: microk8s
     kind: Config
     preferences: {}
     users:
     - name: admin
       user:
         token: dFdyOHBDV21VZmNNbGJyR1ZMQU02WVVXRGF3YW9HU2hwR3ZpeTBYenpzaz0K
     - name: ivan
       user:
         client-certificate: /home/ivan/.certs/ivan.crt
         client-key: /home/ivan/.certs/ivan.key
   ```
3. Создал [файл ролей](/practice/12.9/role-users.yaml) и [прав](/practice/12.9/role-binding.yaml) для пользователя.
4. В вышеуказанном файле прописал права пользователя `verbs: ["get", "watch", "list"]`.
5. Запустил [Pod](/practice/12.9/pod.yaml), пробую от пользователя `ivan` совершить действия просмотра и создания:
   * как видим, пользователь может просматривать под:  
   ![](/pics/12.9/ivan-get-pods.jpg)  
   * до момента конфигурации файла из п.2 промсотреть под было невозможно, но к сожалению я не сделал скриншот.
   * пробуем создать под, и как видим, у нашего пользователя нет на это прав:  
   ![](/pics/12.9/ivan-create-pod.jpg)  
6. На этом считаю задание выполненным.

