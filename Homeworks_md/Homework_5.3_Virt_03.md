# devops-netology
### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера".

### Задача 1.
* создайте свой репозиторий на https://hub.docker.com;
* выберете любой образ, который содержит веб-сервер Nginx;
* создайте свой fork образа;
* реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```html
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на [https://hub.docker.com/username_repo](https://hub.docker.com/username_repo).
#### Ответ:
В качестве исходного образа взят образ Docker [nginx:latest](https://hub.docker.com/_/nginx).  
При сборке своего образа, в Docker файле я прописал команду копирования заранее подготовленного файла index.html с необходимым содержимым внутрь контейнера.  
Ссылки на файлы:
* [Dockerfile](/practice/05.3-Docker/Dockerfile)
* [index.html](/practice/05.3-Docker/index.html)

Запуск контейнера осуществил командой:   
```shell
egor@netology:~$ docker pull egorz/nginx-netology:1.23.2
egor@netology:~$ docker run -d -p 8080:80 egorz/nginx-netology:1.23.2
```
Зашел через браузер и увидел результат:  
  
![](../pics/5.3/nginx_docker.jpg)  
 

Ссылка на репозиторий: [egorz/nginx-netology:1.23.2](https://hub.docker.com/repository/docker/egorz/nginx-netology)

### Задача 2.
Посмотрите на сценарий ниже и ответьте на вопрос: "Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:
* Высоконагруженное монолитное java веб-приложение;
* Nodejs веб-приложение;
* Мобильное приложение c версиями для Android и iOS;
* Шина данных на базе Apache Kafka;
* Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
* Мониторинг-стек на базе Prometheus и Grafana;
* MongoDB, как основное хранилище данных для java-приложения;
* Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

#### Ответ:
* Высоконагруженное монолитное java веб-приложение. Т.к. приложение монолитное, предполагающее сборку всех компонентов в одном месте (фронтенд, бэкенд и т.п.), и к тому же высоконагруженное, то здесь подойдет физический сервер.
* Nodejs веб-приложение. В этом случае подойдет контейнеризация Docker, т.к. Nodejs не требует много ресурсов. Такой подход особенно следует выделить в рамках микросервисной архитектуры приложения.
* Мобильное приложение c версиями для Android и iOS. Полагаю что здесь лучше использовать вритупльную машину, т.к. приложение в Docker контейнере не имеет своего UI.
* Шина данных на базе Apache Kafka. понимаю, что данный сервис обеспечивает трансляцию из одного формата данных приложения в другое. Здесь можно использовать Docker, ввиду невысокой требовательности к ресурсам.
* Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana. Здесь можно использовать комбинированное решение: например elasticsearch
располагается на виртуальных машинах с обеспечением отказоустойчивости с помощью кластеризации, а logstash и kibana - в Docker контейнерах, также в кластере. Хотя не вижу противопоказаний вообще все сервисы расположить в контейнерах Docker с обеспечением отказоустойчивости на уровне кластеров.
* Мониторинг-стек на базе Prometheus и Grafana. Для использования данных систем прекрасно подойдет Docker, т.к. его проще развернуть и масштабировать в дальнейшем для различных задач.
* MongoDB, как основное хранилище данных для java-приложения. Думаю что здесь лучше использовать виртуальную машину, т.к. это хранилище, а Docker контейнер не подходит для хранения данных. Если данное хранилище является высоконагруженным - то лучше использовать физический сервер.
* Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry. В данном случае лучше использовать виртуальную машину или физический сервер. В данном случае, конечно, все зависит от предполагаемого объема информации для хранения.

### Задача 3.
* Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку `/data` из текущей рабочей директории на хостовой машине в `/data` контейнера;
* Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку `/data` из текущей рабочей директории на хостовой машине в `/data` контейнера;
* Подключитесь к первому контейнеру с помощью `docker exec` и создайте текстовый файл любого содержания в `/data`;
* Добавьте еще один файл в папку `/data` на хостовой машине;
* Подключитесь во второй контейнер и отобразите листинг и содержание файлов в `/data` контейнера.

#### Ответ:
* Запускаю первый контейнер из образа ***centos***:
```shell
egor@netology:~$ docker run -d -it -v ~/data:/data centos /bin/bash
ed214535f7cd57a2b94415959391b06ef0455f42ed347d3225abf7aa4d0e35bd
egor@netology:~$ docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
ed214535f7cd   centos    "/bin/bash"   31 seconds ago   Up 27 seconds             nifty_cray
```
* Запускаю второй контейнер из образа ***debian***:
```shell
egor@netology:~$ docker run -d -it -v ~/data:/data debian /bin/bash
4fd0e32d641949175a9f707e15f54547b8f8dacb7ffd54a2cba265da0cb856ab
egor@netology:~$ docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
4fd0e32d6419   debian    "/bin/bash"   18 seconds ago   Up 13 seconds             nice_ptolemy
ed214535f7cd   centos    "/bin/bash"   31 seconds ago   Up 27 seconds             nifty_cray
```
* Подключаюсь к первому контейнеру ***centos*** с помощью `docker exec` и создаю текстовый файл любого содержания в `/data`:
```shell
egor@netology:~$ docker exec -it nifty_cray /bin/bash
[root@ed214535f7cd /]# ls -lha
total 60K
drwxr-xr-x   1 root root 4.0K Nov  4 10:27 .
drwxr-xr-x   1 root root 4.0K Nov  4 10:27 ..
-rwxr-xr-x   1 root root    0 Nov  4 10:27 .dockerenv
lrwxrwxrwx   1 root root    7 Nov  3  2020 bin -> usr/bin
drwxrwxr-x   2 1000 1000 4.0K Nov  4 10:05 data
drwxr-xr-x   5 root root  360 Nov  4 10:27 dev
drwxr-xr-x   1 root root 4.0K Nov  4 10:27 etc
drwxr-xr-x   2 root root 4.0K Nov  3  2020 home
lrwxrwxrwx   1 root root    7 Nov  3  2020 lib -> usr/lib
lrwxrwxrwx   1 root root    9 Nov  3  2020 lib64 -> usr/lib64
drwx------   2 root root 4.0K Sep 15  2021 lost+found
drwxr-xr-x   2 root root 4.0K Nov  3  2020 media
drwxr-xr-x   2 root root 4.0K Nov  3  2020 mnt
drwxr-xr-x   2 root root 4.0K Nov  3  2020 opt
dr-xr-xr-x 241 root root    0 Nov  4 10:27 proc
dr-xr-x---   2 root root 4.0K Sep 15  2021 root
drwxr-xr-x  11 root root 4.0K Sep 15  2021 run
lrwxrwxrwx   1 root root    8 Nov  3  2020 sbin -> usr/sbin
drwxr-xr-x   2 root root 4.0K Nov  3  2020 srv
dr-xr-xr-x  13 root root    0 Nov  4 10:27 sys
drwxrwxrwt   7 root root 4.0K Sep 15  2021 tmp
drwxr-xr-x  12 root root 4.0K Sep 15  2021 usr
drwxr-xr-x  20 root root 4.0K Sep 15  2021 var
[root@ed214535f7cd /]# echo 'This 1st file' > /data/centos_first_file
[root@ed214535f7cd /]# ls /data
centos_first_file
[root@ed214535f7cd /]#
```
* Создаю еще файл в хостовой машине:
```shell
egor@netology:~$ ls data
centos_first_file
egor@netology:~$ echo 'This 2nd file' > data/host_second_file
egor@netology:~$ ls data -lha
total 16K
drwxrwxr-x  2 egor egor 4.0K Nov  4 10:33 .
drwxr-xr-x 13 egor egor 4.0K Nov  4 10:05 ..
-rw-r--r--  1 root root   14 Nov  4 10:31 centos_first_file
-rw-rw-r--  1 egor egor   14 Nov  4 10:33 host_second_file
egor@netology:~$
```
* Подключаюсь во второй контейнер ***debian*** и вижу созданные файлы:
```shell
egor@netology:~$ docker exec -it nice_ptolemy /bin/bash
root@4fd0e32d6419:/# ls -lha
total 76K
drwxr-xr-x   1 root root 4.0K Nov  4 10:28 .
drwxr-xr-x   1 root root 4.0K Nov  4 10:28 ..
-rwxr-xr-x   1 root root    0 Nov  4 10:27 .dockerenv
drwxr-xr-x   2 root root 4.0K Oct 24 00:00 bin
drwxr-xr-x   2 root root 4.0K Sep  3 12:10 boot
drwxrwxr-x   2 1000 1000 4.0K Nov  4 10:33 data
drwxr-xr-x   5 root root  360 Nov  4 10:28 dev
drwxr-xr-x   1 root root 4.0K Nov  4 10:27 etc
drwxr-xr-x   2 root root 4.0K Sep  3 12:10 home
drwxr-xr-x   8 root root 4.0K Oct 24 00:00 lib
drwxr-xr-x   2 root root 4.0K Oct 24 00:00 lib64
drwxr-xr-x   2 root root 4.0K Oct 24 00:00 media
drwxr-xr-x   2 root root 4.0K Oct 24 00:00 mnt
drwxr-xr-x   2 root root 4.0K Oct 24 00:00 opt
dr-xr-xr-x 224 root root    0 Nov  4 10:28 proc
drwx------   1 root root 4.0K Nov  4 10:43 root
drwxr-xr-x   3 root root 4.0K Oct 24 00:00 run
drwxr-xr-x   2 root root 4.0K Oct 24 00:00 sbin
drwxr-xr-x   2 root root 4.0K Oct 24 00:00 srv
dr-xr-xr-x  13 root root    0 Nov  4 10:28 sys
drwxrwxrwt   2 root root 4.0K Oct 24 00:00 tmp
drwxr-xr-x  11 root root 4.0K Oct 24 00:00 usr
drwxr-xr-x  11 root root 4.0K Oct 24 00:00 var
root@4fd0e32d6419:/# ls -lha /data
total 16K
drwxrwxr-x 2 1000 1000 4.0K Nov  4 10:33 .
drwxr-xr-x 1 root root 4.0K Nov  4 10:28 ..
-rw-r--r-- 1 root root   14 Nov  4 10:31 centos_first_file
-rw-rw-r-- 1 1000 1000   14 Nov  4 10:33 host_second_file
root@4fd0e32d6419:/# cat /data/centos_first_file
This 1st file
root@4fd0e32d6419:/# cat /data/host_second_file
This 2nd file
root@4fd0e32d6419:/#
```

### Задача 4.
Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

### Ответ:
* Собрал образ с Ansible:
```shell
egor@netology:~$ docker image ls
REPOSITORY             TAG       IMAGE ID       CREATED         SIZE
egorz/nginx-netology   1.23.2    8c72f3a5aa08   7 hours ago     142MB
egorz/ansible          2.9.24    3fbed9875d34   8 hours ago     245MB
```
* Запускаю данный образ:
```shell
egor@netology:~$ docker run -it egorz/ansible:2.9.24 ansible --version
ansible [core 2.13.5]
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.9/site-packages/ansible
  ansible collection location = /root/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.9.5 (default, Nov 24 2021, 21:19:13) [GCC 10.3.1 20210424]
  jinja version = 3.1.2
  libyaml = False
egor@netology:~$
```
* Ссылка на образ: [egorz/ansible:2.9.24](https://hub.docker.com/repository/docker/egorz/ansible)