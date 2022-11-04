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
* [Dockerfile](Docker/5.3/Dockerfile)
* [index.html](Docker/5.3/index.html)

Запуск контейнера осуществил командой:   
```shell
egor@netology:~$ docker run -d -p 8080:80 egorz/nginx-netology:1.23.2
```
Зашел через браузер и увидел результат:  
  
![](pics/5.3/nginx_docker.jpg)  
 

Ссылка на репозиторий: [egorz/nginx-netology:1.23.2](https://hub.docker.com/repository/docker/egorz/nginx-netology)

### Задача 2.