# devops-netology

### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию 13.2 «Установка Kubernetes»

### Цель задания

Установить кластер K8s.

### Чеклист готовности к домашнему заданию

1. Развёрнутые ВМ с ОС Ubuntu 20.04-lts.


### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция по установке kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/).
2. [Документация kubespray](https://kubespray.io/).

-----

### Задание 1. Установить кластер k8s с 1 master node

1. Подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды.
2. В качестве CRI — containerd.
3. Запуск etcd производить на мастере.
4. Способ установки выбрать самостоятельно.

### Ответ:

1. Подготовил 5 виртуальных машин с помощью [terraform](/practice/13.2/terraform/main.tf). Машины запущены в Yandex.Cloud:  
   ![](/pics/13.2/5-vm.jpg)   
2. Выполнил установку на мастер-ноду, привожу пример только с мастер-ноды:
    ```shell
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl
    curl -fsSL https://dl.k8s.io/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl containerd
    sudo apt-mark hold kubelet kubeadm kubectl
    ```
3. На каждом их серверов выполнил :
   ```shell
   modprobe br_netfilter
   echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
   echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
   echo "net.bridge.bridge-nf-call-arptables=1" >> /etc/sysctl.conf
   echo "net.bridge.bridge-nf-call-ip6tables=1" >> /etc/sysctl.conf
   sysctl -p /etc/sysctl.conf
   ```
4. Инициализировал мастера:
   ```shell
   kubeadm init \
    --apiserver-advertise-address=10.0.90.13 \
    --pod-network-cidr 10.244.0.0/16 \
    --apiserver-cert-extra-sans=158.160.34.143 \
    --control-plane-endpoint=192.168.1.34
   ```
5. Инициализировал на каждом worker:
```shell
kubeadm join \
 192.168.1.34:6443 \
 --token v1gyhn.qnhboinnm4646l4l \
 --discovery-token-ca-cert-hash sha256:30484d54a958bc7f8bca79c072a8875c7d5c90112279fc0f6659243ec5afdb35
```
6. Кластер собран, для проверки на мастере создал тестовый deployment:
```shell
egor@netology-master-01:~$ kubectl create deploy nginx --image=nginx:latest --replicas=8
```
7. Видим что deployment создан, также привожу ноды кластера:
   ![](/pics/13.2/test-deployment.jpg)  
8. Считаю что на этом задание выполнено.
