# devops-netology

### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию 12.8 «Конфигурация приложений»

### Цель задания

В тестовой среде Kubernetes необходимо создать конфигурацию и продемонстрировать работу приложения.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8s).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым GitHub-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/configuration/secret/) Secret.
2. [Описание](https://kubernetes.io/docs/concepts/configuration/configmap/) ConfigMap.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment приложения и решить возникшую проблему с помощью ConfigMap. Добавить веб-страницу

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Решить возникшую проблему с помощью ConfigMap.
3. Продемонстрировать, что pod стартовал и оба конейнера работают.
4. Сделать простую веб-страницу и подключить её к Nginx с помощью ConfigMap. Подключить Service и показать вывод curl или в браузере.
5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

### Ответ:

1. Создал [Deployment](/practice/12.8/task1/deployment-task1.yaml) приложения, состоящего из контейнеров busybox и multitool. Поскольку похожая задача уже была, и я знаю что приложение не запустится из-за того, что оба контейнера используют один и тот же порт, я сразу указал в манифесте в разделе `env`, какой порт использовать контейнеру `multitool`.
2. Фрагмент из манифеста, решающий проблему запуска. Порт для `multitool` указан с помощью [Configmap](/practice/12.8/task1/configmap-task1.yaml):  
    ```yaml
    name: multitool
    env:
    - name: HTTP_PORT
      valueFrom:
        configMapKeyRef:
          name: t1-configmap
          key: http-port
   ```
3. Запустил наш Deployment, оба контейнера работают:  
    ![](/pics/12.8/task1-deployment-running.jpg)  
4. Создал также с помощью [Configmap](/practice/12.8/task1/configmap-task1.yaml) простую страницу и подключил ее к контейнеру `nginx`:
    ```yaml
    data:
      http-port: "8080"
      index.html:
        <html>
        <h1>Welcome to Netology!</h1>
        </br>
        <h3>This is main page!</h3>
        </html>
    ```  
5. Перезапустил наш Deployment и Configmap, создал [Service](/practice/12.8/task1/service-task1.yaml) для подключения к подам:
    * видим что вновь созданные контейнеры работают:  
    ![](/pics/12.8/task1-deployment-running-after-restart.jpg)  
    * зашел внутрь пода командой `kubectl exec -it task1-69f7857545-xm4mt -c=nginx sh`, увидел созданную страничку:  
    ![](/pics/12.8/task1-into-nginx-pod.jpg)  
    * запустил проброс порта командой `kubectl port-forward svc/netology-svc 3000:8001 --address='192.168.1.74'` и зашел через браузер:  
    ![](/pics/12.8/task1-nginx-main-page.jpg)  
    * также видим в консоли что подключение есть, все работает:  
    ![](/pics/12.8/task1-connect-3000.jpg)  
6. На этом данное задание завершено.
------

### Задание 2. Создать приложение с вашей веб-страницей, доступной по HTTPS 

1. Создать Deployment приложения, состоящего из Nginx.
2. Создать собственную веб-страницу и подключить её как ConfigMap к приложению.
3. Выпустить самоподписной сертификат SSL. Создать Secret для использования сертификата.
4. Создать Ingress и необходимый Service, подключить к нему SSL в вид. Продемонстировать доступ к приложению по HTTPS. 
5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

### Ответ:
1. Создал [Deployment](/practice/12.8/task2/deployment-task2.yaml) приложения, состоящего из Nginx.
2. Создал собственную веб-страницу и подключил её как [ConfigMap](/practice/12.8/task2/configmap-task2.yaml) к приложению.
3. Выпустил самоподписной сертификат SSL:  
    ![](/pics/12.8/task2-create-SSL-certs.jpg)  
    получил сертификат и ключ:  
    ![](/pics/12.8/task2-list-certs.jpg)  
4. Создал [Secret](/practice/12.8/task2/secret-task2.yaml) для использования сертификата.
5. Создал [Ingress](/practice/12.8/task2/ingress-task2.yaml) и необходимый [Service](/practice/12.8/task2/service-task2.yaml), подключил к нему SSL.
6. Запустил приложение, прошел по адресу `https://netology.local`, увидел нашу страницу:
    ![](/pics/12.8/task2-connect-browser.jpg)  
7. Задание завершено.
------

### Правила приёма работы

1. Домашняя работа оформляется в своём GitHub-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------