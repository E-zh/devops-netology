# devops-netology

### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию «Безопасность в облачных провайдерах»  

Используя конфигурации, выполненные в рамках предыдущих домашних заданий, нужно добавить возможность шифрования бакета.

---
## Задание 1. Yandex Cloud   

1. С помощью ключа в KMS необходимо зашифровать содержимое бакета:

 - создать ключ в KMS;
 - с помощью ключа зашифровать содержимое бакета, созданного ранее.
2. (Выполняется не в Terraform)* Создать статический сайт в Object Storage c собственным публичным адресом и сделать доступным по HTTPS:

 - создать сертификат;
 - создать статическую страницу в Object Storage и применить сертификат HTTPS;
 - в качестве результата предоставить скриншот на страницу с сертификатом в заголовке (замочек).

Полезные документы:

- [Настройка HTTPS статичного сайта](https://cloud.yandex.ru/docs/storage/operations/hosting/certificate).
- [Object Storage bucket](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket).
- [KMS key](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kms_symmetric_key).

### Правила приёма работы

Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

---

### Ответ:
1. Модифицировал файл [main.tf](/practice/14.3/main.tf) из предыдущего задания. С помощью ключа в KMS зашифровал содержимое бакета:
    * создал KMS ключ:  
    ```yaml
    resource "yandex_kms_symmetric_key" "key-1" {
      name              = "key-1"
      description       = "Bucket Encryption Key"
      default_algorithm = "AES_128"
      rotation_period   = "8760h" # 1 Year
    }
    ```
   * создаем бакет с указанными ключами и шифрованием:  
    ```yaml
    resource "yandex_storage_bucket" "vp-bucket" {
      access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
      secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
      bucket     = "vp-netology-bucket"
    
      max_size = 1073741824 # 1 Gb
    
      anonymous_access_flags {
        read = true
        list = false
      }
    
      server_side_encryption_configuration {
        rule {
          apply_server_side_encryption_by_default {
            kms_master_key_id = yandex_kms_symmetric_key.key-1.id
            sse_algorithm     = "aws:kms"
          }
        }
      }
    }
    ```
    * выполнил `export TF_VAR_yc_token=$(yc iam create-token)` и запустил `terraform apply`:  
    ![](/pics/14.3/1-terraform-apply.jpg)  
    * проходим по адресу `https://vp-netology-test-bucket.storage.yandexcloud.net/image.png`:  
    ![](/pics/14.3/2-image.jpg)  
    * это происходит потому что используется шифрование объектов в бакете, и для доступа необходимо использовать запрос с указанием ключа.
2. Создал статический сайт в Object Storage c собственным публичным адресом и сделал его доступным по HTTPS:
    * создал сертификат:  
    ![](/pics/14.3/3-cert.jpg)  
    * создал статическую страницу из [файла index.html](/practice/14.3/index.html)
    * создал сайт `zhelobanov.ru` в Object Storage:  
    ![](/pics/14.3/3-site.jpg)  
    * выполнил необходимые настройки, переходим по адресу, и видим нужную страницу:  
    ![](/pics/14.3/4-success.jpg)
3. На этом выполнение задания завершено.
