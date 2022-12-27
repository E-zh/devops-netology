# devops-netology
### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

Бывает, что 
* общедоступная документация по терраформ ресурсам не всегда достоверна,
* в документации не хватает каких-нибудь правил валидации или неточно описаны параметры,
* понадобиться использовать провайдер без официальной документации,
* может возникнуть необходимость написать свой провайдер для системы используемой в ваших проектах.   

### Задача 1. 
Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: 
[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).
Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.  


1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе.   
2. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`. 
    * С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.
    * Какая максимальная длина имени? 
    * Какому регулярному выражению должно подчиняться имя? 

#### Ответ:
1. Клонировал вышеуказанный репозиторий:
```shell
git clone git@github.com:hashicorp/terraform-provider-aws.git
Cloning into 'terraform-provider-aws'...
remote: Enumerating objects: 451970, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (5/5), done.
remote: Total 451970 (delta 0), reused 1 (delta 0), pack-reused 451965
Receiving objects: 100% (451970/451970), 417.59 MiB | 6.96 MiB/s, done.

Resolving deltas: 100% (327159/327159), done.
Updating files: 100% (10944/10944), done.
```
2. Нашел где перечислены `resource` и `data_source`, ссылки прилагаю:
    * `DataSourcesMap: map[string]*schema.Resource` - [ссылка](https://github.com/hashicorp/terraform-provider-aws/blob/d9290535ae088a600ddec41fe63e899185d74b56/internal/provider/provider.go#L419)
    * `ResourcesMap: map[string]*schema.Resource` - [ссылка](https://github.com/hashicorp/terraform-provider-aws/blob/d9290535ae088a600ddec41fe63e899185d74b56/internal/provider/provider.go#L943)
3. Параметр `name` ресурса `aws_sqs_queue`:
    * конфликтует с `ConflictsWith: []string{"name_prefix"}` - [ссылка](https://github.com/hashicorp/terraform-provider-aws/blob/d9290535ae088a600ddec41fe63e899185d74b56/internal/service/sqs/queue.go#L88)
    * максимальная длина имени 80 символов - [ссылка](https://github.com/hashicorp/terraform-provider-aws/blob/d9290535ae088a600ddec41fe63e899185d74b56/internal/service/sqs/queue.go#L433)
    * регулярное выражение для имени - [ссылка](https://github.com/hashicorp/terraform-provider-aws/blob/d9290535ae088a600ddec41fe63e899185d74b56/internal/service/sqs/queue.go#L433)
    
### Задача 2. (Не обязательно) 
В рамках вебинара и презентации мы разобрали как создать свой собственный провайдер на примере кофемашины. 
Также вот официальная документация о создании провайдера: 
[https://learn.hashicorp.com/collections/terraform/providers](https://learn.hashicorp.com/collections/terraform/providers).

1. Проделайте все шаги создания провайдера.
2. В виде результата приложение ссылку на исходный код.
3. Попробуйте скомпилировать провайдер, если получится то приложите снимок экрана с командой и результатом компиляции.   
