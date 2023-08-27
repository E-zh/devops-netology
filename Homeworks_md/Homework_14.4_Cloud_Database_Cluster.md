# devops-netology

### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию 14.4 «Кластеры. Ресурсы под управлением облачных провайдеров»

### Цели задания 

1. Организация кластера Kubernetes и кластера баз данных MySQL в отказоустойчивой архитектуре.
2. Размещение в private подсетях кластера БД, а в public — кластера Kubernetes.

---
## Задание 1. Yandex Cloud

1. Настроить с помощью Terraform кластер баз данных MySQL.

 - Используя настройки VPC из предыдущих домашних заданий, добавить дополнительно подсеть private в разных зонах, чтобы обеспечить отказоустойчивость. 
 - Разместить ноды кластера MySQL в разных подсетях.
 - Необходимо предусмотреть репликацию с произвольным временем технического обслуживания.
 - Использовать окружение Prestable, платформу Intel Broadwell с производительностью 50% CPU и размером диска 20 Гб.
 - Задать время начала резервного копирования — 23:59.
 - Включить защиту кластера от непреднамеренного удаления.
 - Создать БД с именем `netology_db`, логином и паролем.

2. Настроить с помощью Terraform кластер Kubernetes.

 - Используя настройки VPC из предыдущих домашних заданий, добавить дополнительно две подсети public в разных зонах, чтобы обеспечить отказоустойчивость.
 - Создать отдельный сервис-аккаунт с необходимыми правами. 
 - Создать региональный мастер Kubernetes с размещением нод в трёх разных подсетях.
 - Добавить возможность шифрования ключом из KMS, созданным в предыдущем домашнем задании.
 - Создать группу узлов, состояющую из трёх машин с автомасштабированием до шести.
 - Подключиться к кластеру с помощью `kubectl`.
 - *Запустить микросервис phpmyadmin и подключиться к ранее созданной БД.
 - *Создать сервис-типы Load Balancer и подключиться к phpmyadmin. Предоставить скриншот с публичным адресом и подключением к БД.

Полезные документы:

- [MySQL cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_cluster).
- [Создание кластера Kubernetes](https://cloud.yandex.ru/docs/managed-kubernetes/operations/kubernetes-cluster/kubernetes-cluster-create)
- [K8S Cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster).
- [K8S node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group).

---

### Ответ:
1. Настроил с помощью Terraform кластер баз данных MySQL:
    * для отказоустойчивости добавил дополнительно подсеть private в разных зонах:  
    ```yaml
    resource "yandex_vpc_network" "netology-network" {
      name = "netology-network"
    }
    
    resource "yandex_vpc_subnet" "private-1" {
      name           = "private-1"
      v4_cidr_blocks = ["192.168.10.0/24"]
      zone           = "ru-central1-a"
      network_id     = yandex_vpc_network.netology-network.id
    }
    
    resource "yandex_vpc_subnet" "private-2" {
      name           = "private-2"
      v4_cidr_blocks = ["192.168.20.0/24"]
      zone           = "ru-central1-b"
      network_id     = yandex_vpc_network.netology-network.id
    }
    
    resource "yandex_vpc_subnet" "private-3" {
      name           = "private-3"
      v4_cidr_blocks = ["192.168.30.0/24"]
      zone           = "ru-central1-c"
      network_id     = yandex_vpc_network.netology-network.id
    }
    ```
    * разместил ноды кластера MySQL в разных подсетях:  
    ```yaml
    host {
        name      = "node-1"
        zone      = "ru-central1-a"
        subnet_id = yandex_vpc_subnet.private-1.id
      }
      host {
        name      = "node-2"
        zone      = "ru-central1-b"
        subnet_id = yandex_vpc_subnet.private-2.id
      }
      host {
        name      = "node-3"
        zone      = "ru-central1-c"
        subnet_id = yandex_vpc_subnet.private-3.id
      }
    ```
   * предусмотрел репликацию с произвольным временем технического обслуживания:  
   ```yaml
    maintenance_window {
        type = "ANYTIME"
      }
    ```
   * использовал окружение `Prestable`, платформу `Intel Broadwell` с производительностью `50% CPU` и размером диска `20 Гб`:  
   ```yaml
    resources {
        resource_preset_id = "b1.medium"
        disk_type_id       = "network-ssd"
        disk_size          = "20"
      }
    ```
   * задал время начала резервного копирования — 23:59:  
   ```yaml
    backup_window_start {
        hours   = "23"
        minutes = "59"
      }
    ```
   * включил защиту кластера от непреднамеренного удаления:  
   ```yaml
    deletion_protection = true
    ```
   * создал БД с именем `netology_db`, логином и паролем:  
   ```yaml
    resource "yandex_mdb_mysql_database" "netology_db" {
      cluster_id = yandex_mdb_mysql_cluster.vp-mysql-01.id
      name       = var.database_name
    }
    
    resource "yandex_mdb_mysql_user" "database_user" {
      cluster_id = yandex_mdb_mysql_cluster.vp-mysql-01.id
      name       = var.database_user
      password   = var.database_password
      permission {
        database_name = yandex_mdb_mysql_database.netology_db.name
        roles         = ["ALL"]
      }
    }
    ```
   * выполнил `export TF_VAR_yc_token=$(yc iam create-token)` и запустил `terraform apply`:  
   ![](/pics/14.4/1-terraform-apply.jpg)   
   * получаем вывод информации о создавшемся кластере:  
   ![](/pics/14.4/1-created-mysql-cluster-info.jpg)  
   * проверяем в `Yandex.Cloud`, видим что кластер создался и работает:  
   ![](/pics/14.4/2-running-mysql-cluster.jpg)  
   * прилагаю полный [манифест main.tf](/practice/14.4/main.tf) для Terraform.

2. Настроил с помощью Terraform кластер Kubernetes:
   * добавил дополнительно подсети `public` в разных зонах для отказоустойчивости:  
   ```yaml
   resource "yandex_vpc_subnet" "public-1" {
     name           = "public-1"
     v4_cidr_blocks = ["192.168.40.0/24"]
     zone           = "ru-central1-a"
     network_id     = yandex_vpc_network.netology-network.id
   }
   
   resource "yandex_vpc_subnet" "public-2" {
     name           = "public-2"
     v4_cidr_blocks = ["192.168.50.0/24"]
     zone           = "ru-central1-b"
     network_id     = yandex_vpc_network.netology-network.id
   }
   
   resource "yandex_vpc_subnet" "public-3" {
     name           = "public-3"
     v4_cidr_blocks = ["192.168.60.0/24"]
     zone           = "ru-central1-c"
     network_id     = yandex_vpc_network.netology-network.id
   }
   ```
   * создал отдельный сервис-аккаунт с необходимыми правами:  
   ```yaml
   resource "yandex_iam_service_account" "kuber-sa-account" {
     description = "Service account for K8S cluster"
     name        = var.kuber-sa-name
   }
   
   ## role "k8s.clusters.agent"
   resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
     folder_id = var.yc_folder_id
     role      = "k8s.clusters.agent"
     member    = "serviceAccount:${yandex_iam_service_account.kuber-sa-account.id}"
   }
   
   ## role "vpc.publicAdmin"
   resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
     folder_id = var.yc_folder_id
     role      = "vpc.publicAdmin"
     member    = "serviceAccount:${yandex_iam_service_account.kuber-sa-account.id}"
   }
   
   ## role "container-registry.images.puller"
   resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
     folder_id = var.yc_folder_id
     role      = "container-registry.images.puller"
     member    = "serviceAccount:${yandex_iam_service_account.kuber-sa-account.id}"
   }
   
   ## role "load-balancer.admin"
   resource "yandex_resourcemanager_folder_iam_member" "kuber-sa-lb-admin" {
     folder_id = var.yc_folder_id
     role      = "load-balancer.admin"
     member    = "serviceAccount:${yandex_iam_service_account.kuber-sa-account.id}"
   }
   
   ## create key for encrypt important information (ex: OAuth-tokens, SSH-keys, passwords)
   resource "yandex_kms_symmetric_key" "kms-key" {
     name              = "kms-key"
     default_algorithm = "AES_128"
     rotation_period   = "8760h" # 1 год.
   }
   
   ## provide access to the encryption key
   resource "yandex_kms_symmetric_key_iam_binding" "viewer" {
     symmetric_key_id = yandex_kms_symmetric_key.kms-key.id
     role             = "viewer"
     members          = [
       "serviceAccount:${yandex_iam_service_account.kuber-sa-account.id}"
     ]
   }
   ```
   * создал региональный мастер `Kubernetes` с размещением нод в трёх разных подсетях:  
   ```yaml
   resource "yandex_kubernetes_cluster" "k8s-regional" {
     description        = "K8S Cluster"
     name               = "vp-k8s-cluster-01"
     network_id         = yandex_vpc_network.netology-network.id
     cluster_ipv4_range = "10.1.0.0/16"
     service_ipv4_range = "10.2.0.0/16"
   
     master {
       version   = var.k8s_version
       public_ip = true
   
       # Create a regional Kubernetes master with nodes on three different subnets.
       regional {
         region = "ru-central1"
         location {
           zone      = yandex_vpc_subnet.public-1.zone
           subnet_id = yandex_vpc_subnet.public-1.id
         }
         location {
           zone      = yandex_vpc_subnet.public-2.zone
           subnet_id = yandex_vpc_subnet.public-2.id
         }
         location {
           zone      = yandex_vpc_subnet.public-3.zone
           subnet_id = yandex_vpc_subnet.public-3.id
         }
       }
     }
   ```
   * добавил возможность шифрования ключом из KMS:  
   ```yaml
   kms_provider {
       key_id = yandex_kms_symmetric_key.kms-key.id
     }
   ```
   * создал группу узлов, состояющую из трёх машин с автомасштабированием до шести:  
   ```yaml
   resource "yandex_kubernetes_node_group" "k8s-ng-01" {
     description = "Группа узлов для кластера"
     cluster_id  = yandex_kubernetes_cluster.k8s-regional.id
     name        = "k8s-ng-01"
     instance_template {
       platform_id = "standard-v2"
       container_runtime {
         type = "containerd"
       }
       network_interface {
         nat        = true
         subnet_ids = [yandex_vpc_subnet.public-1.id]
       }
       scheduling_policy {
         preemptible = true
       }
       metadata = {
         ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
       }
     }
   
     scale_policy {
       auto_scale {
         initial = 3
         max     = 6
         min     = 3
       }
     }
     allocation_policy {
       location {
         zone = "ru-central1-a"
       }
     }
   
     depends_on = [
       yandex_kubernetes_cluster.k8s-regional,
       yandex_vpc_subnet.public-1
     ]
   
   }
   ```
   * запускаем `terraform apply`:  
   ![](/pics/14.4/3-terraform-apply.jpg)  
   * получаем вывод информации о создавшемся кластере:  
   ![](/pics/14.4/3-created-k8s-cluster.jpg)  
   * проверяем в `Yandex.Cloud`, видим что кластер создался и работает:  
   ![](/pics/14.4/4-running-k8s-cluster.jpg)  
   * подключился к кластеру с помощью `kubectl`, предварительно выполнив команду ` yc managed-kubernetes cluster get-credentials --id catf3bj2psurrl4f569s --external`:  
   ![](/pics/14.4/5-connect-to-k8s-cluster.jpg)  
   * запустил микросервис `phpmyadmin` и подключился к ранее созданной БД:  
      * [sa.yaml](/practice/14.4/kubectl/sa.yaml)
      * [mysql_secret.yaml](/practice/14.4/kubectl/mysql_secret.yaml)
      * [deployment-phpmyadmin.yaml](/practice/14.4/kubectl/deployment-phpmyadmin.yaml)
   ![](/pics/14.4/6-kubectl-deployment.jpg)  
   * создал сервис-типы `Load Balancer` и подключился к phpmyadmin:  
      * [pma-service.yaml](/practice/14.4/kubectl/pma-service.yaml)
   ![](/pics/14.4/7-kubectl-service.jpg)  
   * из скриншота выше видим, что внешний IP сервиса `phpmyadmin-service` - 51.250.3.49. Вводим в браузере и видим:  
   ![](/pics/14.4/8-phpmyadmin.jpg)  
   * пробуем авторизоваться, вводим данные из [vars.tf](/practice/14.4/vars.tf), `database_user` и `database_password`, в моем случае они одинаковы - `netology`:  
   ![](/pics/14.4/9-phpmyadmin-auth.jpg)  
   * для проверки, включил в настройках MySQL кластера доступ к консоли, и создал в БД таблицу:  
   ![](/pics/14.4/10-create-table.jpg)  
   * теперь смотрим в phpmyadmin, и видим только что созданную таблицу:  
   ![](/pics/14.4/11-view-table.jpg)  
3. На этом выполнение домашнего задания завершено.
---

### Правила приёма работы

Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
