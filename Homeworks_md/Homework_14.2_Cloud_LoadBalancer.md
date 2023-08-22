# devops-netology

### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию 14.2 «Вычислительные мощности. Балансировщики нагрузки»  

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию). 
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашних заданий.

---
## Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать бакет Object Storage и разместить в нём файл с картинкой:

 - Создать бакет в Object Storage с произвольным именем (например, _имя_студента_дата_).
 - Положить в бакет файл с картинкой.
 - Сделать файл доступным из интернета.
 
2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:

 - Создать Instance Group с тремя ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`.
 - Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata).
 - Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из бакета.
 - Настроить проверку состояния ВМ.
 
3. Подключить группу к сетевому балансировщику:

 - Создать сетевой балансировщик.
 - Проверить работоспособность, удалив одну или несколько ВМ.

Полезные документы:

- [Compute instance group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance_group).
- [Network Load Balancer](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer).
- [Группа ВМ с сетевым балансировщиком](https://cloud.yandex.ru/docs/compute/operations/instance-groups/create-with-balancer).

---
### Ответ:
1. Создал бакет Object Storage и разместил в нём файл с картинкой:
    ```yaml
    # Create bucket
    resource "yandex_storage_bucket" "vp-bucket" {
      access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
      secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
      bucket     = "vp-netology-bucket"
    
      max_size = 1073741824 # 1 Gb
    
      anonymous_access_flags {
        read = true
        list = false
      }
    }
    
    # Add picture in the bucket
    resource "yandex_storage_object" "my-picture" {
      access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
      secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
      bucket     = yandex_storage_bucket.vp-bucket.id
      key        = "image.png"
      source     = var.yc_image
    }
    ```
2. Создал группу ВМ в `public` подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:
   ```yaml
   # VM group
   resource "yandex_compute_instance_group" "vp-nlb-ig" {
     name               = "vp-nlb-ig"
     folder_id          = var.yc_folder_id
     service_account_id = "${yandex_iam_service_account.iam-sa.id}"
     instance_template {
       platform_id = "standard-v1"
       resources {
         memory = 2
         cores  = 2
       }
   
       boot_disk {
         initialize_params {
           image_id = "fd827b91d99psvq5fjit" # LAMP image
        }
       }
   
       network_interface {
         network_id = "${yandex_vpc_network.netology-net.id}"
         subnet_ids = ["${yandex_vpc_subnet.public.id}"]
       }
   
       metadata = {
         ssh-keys  = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
         user-data = "#!/bin/bash\n cd /var/www/html\n echo \"<html><h2>Домашнее задание: &#171;Вычислительные мощности. Балансировщики нагрузки&#187;</h2><img src='https://${yandex_storage_bucket.vp-bucket.bucket_domain_name}/${yandex_storage_object.my-picture.key}'></html>\" > index.html"
       }
       labels = {
         group = "network-load-balanced"
        }
   
       scheduling_policy {
         preemptible = true
       }
     }
   
     scale_policy {
       fixed_scale {
         size = 3
       }
     }
   
     allocation_policy {
       zones = [var.yc_region]
     }
   
     deploy_policy {
       max_unavailable = 2
       max_expansion   = 1
     }
   
     health_check {
       interval = 2
       timeout = 1
       healthy_threshold = 5
       unhealthy_threshold = 2
       http_options {
         path = "/"
         port = 80
       }
     }
   
     load_balancer {
       target_group_name        = "vp-target-nlb-group"
       target_group_description = "Target group for network balancer"
     }
   }
   ```
3. Подключил группу к сетевому балансировщику:
   ```yaml
   # Network load balancer
   resource "yandex_lb_network_load_balancer" "vp-nlb-1" {
     name = "network-load-balancer-1"
   
     listener {
       name = "network-load-balancer-1-listener"
       port = 80
       external_address_spec {
         ip_version = "ipv4"
       }
     }
   
     attached_target_group {
       target_group_id = yandex_compute_instance_group.vp-nlb-ig.load_balancer.0.target_group_id
   
       healthcheck {
         name = "http"
         interval = 2
         timeout = 1
         unhealthy_threshold = 2
         healthy_threshold = 5
         http_options {
           port = 80
           path = "/"
         }
       }
     }
   }
   ```
   * прилагаю файлы `terraform` для создания ресурсов:
      - [main.tf](/practice/14.2/main.tf)
      - [vars.tf](/practice/14.2/vars.tf)
   * [файл картинки](/practice/14.2/image.png) для размещения в `bucket`.
   * запустил `export TF_VAR_yc_token=$(yc iam create-token)`, а затем `terraform apply`, процесс прошел без ошибок:  
   ![](/pics/14.2/1-terraform-apply.jpg)  
   * переходим по адресу `158.160.104.57`, и видим нашу картинку:  
   ![](/pics/14.2/2-image.jpg)  
   * так как не указал кодировку, русские символы оказались нечитаемы. Добавил в манифест `main.tf`, в строке html страницы код `<head><meta charset=\"utf-8\"><title>ДЗ YC-Bucket</title></head>`, и повторно запустил `terraform apply`:  
   ![](/pics/14.2/2-terraform-apply.jpg)  
   * как видим, теперь все в порядке:  
   ![](/pics/14.2/3-image.jpg)  
   * список виртуальных машин:  
   ![](/pics/14.2/4-all-vm.jpg)  
   * удаляем одну ВМ:  
   ![](/pics/14.2/5-deleting-vm1.jpg)  
   * а затем еще одну:  
   ![](/pics/14.2/5-deleting-vm2.jpg)  
   * проверяем доступность нашей страницы:  
   ![](/pics/14.2/6-image-allow.jpg)  
   * видим как виртуальные машины начинают восстанавливаться:  
   ![](/pics/14.2/6-provisioning-1vm.jpg)  
4. В этом задании при удалении двух ВМ, страничка со ссылкой на картинку все время оставалась доступной. Данное задание считаю выполненным.
