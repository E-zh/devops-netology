# devops-netology
### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию "6.5. Elasticsearch".

### Задача 1.
В этом задании вы потренируетесь в:

- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и [документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути / c хост-машины

Требования к `elasticsearch.yml`:

- данные path должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:

- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:

- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

#### Ответ:
* собрал контейнер Docker с помощью [Dockerfile](/practice/06.5-Elasticsearch/Dockerfile):
```dockerfile
# Pull base image.
FROM centos:centos7

MAINTAINER Egor Zhelobanov <e.zhelobanov@gmail.com>

RUN groupadd -g 1000 elasticsearch && useradd elasticsearch -u 1000 -g 1000

RUN yum makecache && \
    yum -y install wget \
    yum -y install perl-Digest-SHA

# Install Elasticsearch.
RUN \
  cd / && \
  wget https://mirrors.huaweicloud.com/elasticsearch/7.9.3/elasticsearch-7.9.3-linux-x86_64.tar.gz && \
  wget https://mirrors.huaweicloud.com/elasticsearch/7.9.3/elasticsearch-7.9.3-linux-x86_64.tar.gz.sha512 && \
  shasum -a 512 -c elasticsearch-7.9.3-linux-x86_64.tar.gz.sha512 && \
  tar -xzf elasticsearch-7.9.3-linux-x86_64.tar.gz && \
  rm -f elasticsearch-7.9.3-linux-x86_64.tar.gz && \
  mv /elasticsearch-7.9.3 /elasticsearch

RUN mkdir /var/lib/elasticsearch /var/lib/elasticsearch/logs /var/lib/elasticsearch/data

COPY elasticsearch.yml /elasticsearch/config

RUN chmod -R 777 /elasticsearch && \
    chmod -R 777 /var/lib/elasticsearch/logs && \
    chmod -R 777 /var/lib/elasticsearch/data

USER elasticsearch

CMD ["/elasticsearch/bin/elasticsearch"]

# Expose ports.
EXPOSE 9200
```
* ссылка на образ [egorz/elasticsearch:7.9.3](https://hub.docker.com/repository/docker/egorz/elasticsearch)
* запустил контейнер, сделал запрос 
```shell
egor@netology:~/elasticsearch$ docker run -d -p 9200:9200 egorz/elasticsearch:7.9.3
19ffa04c54e8c29713e865b932849ec3ee788afd3ad865a09ba2ef98cda9afd9
egor@netology:~/elasticsearch$ docker ps
CONTAINER ID   IMAGE                       COMMAND                  CREATED         STATUS         PORTS                                       NAMES
19ffa04c54e8   egorz/elasticsearch:7.9.3   "/elasticsearch/bin/…"   6 seconds ago   Up 4 seconds   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp   objective_gates
egor@netology:~/elasticsearch$ curl http://localhost:9200
{
  "name" : "netology_test",
  "cluster_name" : "netology",
  "cluster_uuid" : "L59VY8vLTgC9SfXmdAdvMw",
  "version" : {
    "number" : "7.9.3",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "c4138e51121ef06a6404866cddc601906fe5c868",
    "build_date" : "2020-10-16T10:36:16.141335Z",
    "build_snapshot" : false,
    "lucene_version" : "8.6.2",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

### Задача 2.
В этом задании вы научитесь:

- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

#### Ответ:
* Добавил индексы:
```shell
curl -X PUT http://localhost:9200/ind-1?pretty -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 1, "number_of_replicas": 0 }}}'
curl -X PUT http://localhost:9200/ind-2?pretty -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 2, "number_of_replicas": 1 }}}'
curl -X PUT http://localhost:9200/ind-3?pretty -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 4, "number_of_replicas": 2 }}}'
```
* Список индексов, используя API:
```shell
egor@netology:~/elasticsearch$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 vMfdj4lSRKa12I15zd1N0Q   1   0          0            0       208b           208b
yellow open   ind-3 eRa3kRglRfq05WZBYfqbiw   4   2          0            0       832b           832b
yellow open   ind-2 j2fK9jCmTkmFBEbQCRDkMg   2   1          0            0       416b           416b
```
* Статус индексов, используя API:
```shell
egor@netology:~/elasticsearch$ curl -X GET 'http://localhost:9200/_cluster/health/ind-1?pretty'
{
  "cluster_name" : "netology",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
egor@netology:~/elasticsearch$ curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty'
{
  "cluster_name" : "netology",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 41.17647058823529
}
egor@netology:~/elasticsearch$ curl -X GET 'http://localhost:9200/_cluster/health/ind-3?pretty'
{
  "cluster_name" : "netology",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 4,
  "active_shards" : 4,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 8,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 41.17647058823529
}
```
* Состояние `yellow` связано с тем, что у данных индексов указано число реплик, а в нашем случае мы имеем только один сервер, собственно реплицировать некуда.
* Удаляем все индексы:
```shell
egor@netology:~/elasticsearch$ curl -X DELETE 'http://localhost:9200/ind-1?pretty'
{
  "acknowledged" : true
}
egor@netology:~/elasticsearch$ curl -X DELETE 'http://localhost:9200/ind-2?pretty'
{
  "acknowledged" : true
}
egor@netology:~/elasticsearch$ curl -X DELETE 'http://localhost:9200/ind-3?pretty'
{
  "acknowledged" : true
}
```

### Задача 3.
В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

#### Ответ:
* В файл [elasticsearch.yml](/practice/06.5-Elasticsearch/elasticsearch.yml) заранее добавил директиву `path.repo: /elasticsearch/snapshots`. Зарегистрировал директорию как `snapshot repository` c именем `netology_backup`:
```shell
egor@netology:~/elasticsearch$ curl -X POST localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/elasticsearch/snapshots" }}'
{
  "acknowledged" : true
}
```
* Создал индекс `test` с 0 реплик и 1 шардом:
```shell
egor@netology:~/elasticsearch$ curl -X PUT http://localhost:9200/test?pretty -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 1, "number_of_replicas": 0 }}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}
egor@netology:~/elasticsearch$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  XKNG8YkWRLiEjPn5EH5MQw   1   0          0            0       208b           208b
egor@netology:~/elasticsearch$
```
* Создал snapshot:
```shell
egor@netology:~/elasticsearch$ curl -X PUT localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true
{"snapshot":{"snapshot":"elasticsearch","uuid":"0MiGttc6R7y4m2zmKtVeLQ","version_id":7090399,"version":"7.9.3","indices":["test"],"data_streams":[],"include_global_state":true,"state":"SUCCESS","start_time":"2022-12-04T12:02:40.288Z","start_time_in_millis":1670155360288,"end_time":"2022-12-04T12:02:40.688Z","end_time_in_millis":1670155360688,"duration_in_millis":400,"failures":[],"shards":{"total":1,"failed":0,"successful":1}}}
```
* Зашел внутрь контейнера, просмотреть содержимое папки `snapshots`:
```shell
egor@netology:~/elasticsearch$ docker ps
CONTAINER ID   IMAGE                       COMMAND                  CREATED          STATUS          PORTS                                       NAMES
19ffa04c54e8   egorz/elasticsearch:7.9.3   "/elasticsearch/bin/…"   41 minutes ago   Up 41 minutes   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp   objective_gates
egor@netology:~/elasticsearch$ docker exec -it objective_gates bash
[elasticsearch@19ffa04c54e8 /]$ ls /elasticsearch/snapshots/ -lha
total 60K
drwxr-xr-x 3 elasticsearch elasticsearch 4.0K Dec  4 12:02 .
drwxrwxrwx 1 root          root          4.0K Dec  4 11:22 ..
-rw-r--r-- 1 elasticsearch elasticsearch  436 Dec  4 12:02 index-0
-rw-r--r-- 1 elasticsearch elasticsearch    8 Dec  4 12:02 index.latest
drwxr-xr-x 3 elasticsearch elasticsearch 4.0K Dec  4 12:02 indices
-rw-r--r-- 1 elasticsearch elasticsearch  29K Dec  4 12:02 meta-0MiGttc6R7y4m2zmKtVeLQ.dat
-rw-r--r-- 1 elasticsearch elasticsearch  269 Dec  4 12:02 snap-0MiGttc6R7y4m2zmKtVeLQ.dat
[elasticsearch@19ffa04c54e8 /]$
```
* Удаляю индекс `test` и создаю индекс `test-2`, вывожу список индексов:
```shell
egor@netology:~/elasticsearch$ curl -X DELETE 'http://localhost:9200/test?pretty'
{
  "acknowledged" : true
}
egor@netology:~/elasticsearch$ curl -X PUT http://localhost:9200/test-2?pretty -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 1, "number_of_replicas": 0 }}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}
egor@netology:~/elasticsearch$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 Qz2GWaVASXGvBzaRPHDYCg   1   0          0            0       208b           208b
egor@netology:~/elasticsearch$
```
* Восстановил состояние кластера из `snapshot`, созданного ранее, вывожу список индексов:
```shell
egor@netology:~/elasticsearch$ curl -X POST "localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?pretty" -H 'Content-Type: application/json' -d' { "indices": "test" }'
{
  "accepted" : true
}
egor@netology:~/elasticsearch$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 Qz2GWaVASXGvBzaRPHDYCg   1   0          0            0       208b           208b
green  open   test   i8pAGNv8QSyq6bXcCuDGEA   1   0          0            0       208b           208b
egor@netology:~/elasticsearch$
```