# devops-netology

### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию 14.1 «Организация сети»

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию). 
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашнее задание по теме «Облачные провайдеры и синтаксис Terraform». Заранее выберите регион (в случае AWS) и зону.

---
### Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.
 - Создать в VPC subnet с названием public, сетью 192.168.10.0/24.
 - Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1.
 - Создать в этой публичной подсети виртуалку с публичным IP, подключиться к ней и убедиться, что есть доступ к интернету.
3. Приватная подсеть.
 - Создать в VPC subnet с названием private, сетью 192.168.20.0/24.
 - Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс.
 - Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее, и убедиться, что есть доступ к интернету.

Resource Terraform для Yandex Cloud:

- [VPC subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet).
- [Route table](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table).
- [Compute Instance](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance).

---
### Ответ:
1. Данное задание выполнялось с помощью terraform.
2. Создал пустую VPC. Выбрал зону `ru-central1-a` для подсети `public`:  
    ```yaml
    resource "yandex_vpc_network" "net-vpc" {
      name = local.network_name
    }
    
    # Подсети
    resource "yandex_vpc_subnet" "public-subnet" {
      name           = local.subnet_name1
      zone           = "ru-central1-a"
      network_id     = yandex_vpc_network.net-vpc.id
      v4_cidr_blocks = ["192.168.10.0/24"]
    }
    ```
3. Далее создан NAT инстанс, в качестве image_id использовал `fd80mrhj8fl2oe87o4e1`:  
   ```yaml
   resource "yandex_compute_image" "nat-vm" {
     name         = "nat-instance-ubuntu"
     source_image = "fd80mrhj8fl2oe87o4e1"
   }
   ```
4. Создана ВИ в публичной сети, подключаемся к ней, и проверяем что у нее есть интернет:  
   ![](/pics/14.1/test-1vm.jpg)    
5. Добавил приватную сеть и правило маршрутизации:  
   ```yaml
   resource "yandex_vpc_subnet" "private-subnet" {
     name           = local.subnet_name2
     zone           = "ru-central1-a"
     network_id     = yandex_vpc_network.net-vpc.id
     v4_cidr_blocks = ["192.168.20.0/24"]
     route_table_id = yandex_vpc_route_table.nat-instance-route.id
   }
   
   resource "yandex_vpc_route_table" "nat-instance-route" {
     name       = "nat-instance-route"
     network_id = yandex_vpc_network.net-vpc.id
     static_route {
       destination_prefix = "192.168.10.254"
       next_hop_address   = yandex_compute_instance.nat-vm.network_interface.0.ip_address
     }
   ```
6. В приватной сети создана ВМ, подключаемся к ней через первую ВМ, и видим что есть доступ к интернету:  
   ![](/pics/14.1/test-2vm.jpg)  
7. Итоговый файл [main.tf](/practice/14.1/main.tf) прилагаю. На этом задание выполнено.
---
### Правила приёма работы

Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
