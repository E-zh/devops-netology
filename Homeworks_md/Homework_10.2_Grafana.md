# devops-netology
### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию 10.2 «Средство визуализации Grafana»

## Обязательные задания

### Задание 1

1. Используя директорию [help](../practice/10.2/help) внутри этого домашнего задания, запустите связку prometheus-grafana.
1. Зайдите в веб-интерфейс grafana, используя авторизационные данные, указанные в манифесте docker-compose.
1. Подключите поднятый вами prometheus, как источник данных.
1. Решение домашнего задания — скриншот веб-интерфейса grafana со списком подключенных Datasource.

### Ответ:
Запустил связку prometheus-grafana с помощью docker-compose, авторизовался, добавил источник данных:  
![](../pics/10.2/1_added_data_source_Prometheus.jpg)  

---

## Задание 2

Изучите самостоятельно ресурсы:

1. [PromQL tutorial for beginners and humans](https://valyala.medium.com/promql-tutorial-for-beginners-9ab455142085).
1. [Understanding Machine CPU usage](https://www.robustperception.io/understanding-machine-cpu-usage).
1. [Introduction to PromQL, the Prometheus query language](https://grafana.com/blog/2020/02/04/introduction-to-promql-the-prometheus-query-language/).

Создайте Dashboard и в ней создайте Panels:

- утилизация CPU для nodeexporter (в процентах, 100-idle);
- CPULA 1/5/15;
- количество свободной оперативной памяти;
- количество места на файловой системе.

Для решения этого задания приведите promql-запросы для выдачи этих метрик, а также скриншот получившейся Dashboard.

### Ответ:
Изучил вышеуказанные ресурсы.  

Создал dashboard `Netology dashboard`, в ней создал Panels:

* утилизация CPU для nodeexporter (в процентах, 100-idle):  
    - `avg by(instance)(rate(node_cpu_seconds_total{job="nodeexporter",mode="idle"}[$__rate_interval])) * 100`
* CPULA 1/5/15:
    - `avg by (instance)(rate(node_load1{}[$__rate_interval]))` - 1 минута
    - `avg by (instance)(rate(node_load5{}[$__rate_interval]))` - 5 минут
    - `avg by (instance)(rate(node_load15{}[$__rate_interval]))` - 15 минут
* количество свободной оперативной памяти:
    - `node_memory_MemFree_bytes{job="nodeexporter"}`
* количество места на файловой системе:
    - `node_filesystem_free_bytes{job="nodeexporter",mountpoint="/"}`

Скриншот получившегося Dashboard:  
![](../pics/10.2/2_dashboard_netology.jpg)  

---

## Задание 3

1. Создайте для каждой Dashboard подходящее правило alert — можно обратиться к первой лекции в блоке «Мониторинг».
1. В качестве решения задания приведите скриншот вашей итоговой Dashboard.

### Ответ:
Создал правила оповещения для Dashboard:  
![](../pics/10.2/3_alert_rules.jpg)  

Как видно на скриншоте, правило отрабатывает:  
![](../pics/10.2/4_alert_ok.jpg)  

---

## Задание 4

1. Сохраните ваш Dashboard. Для этого перейдите в настройки Dashboard, выберите в боковом меню «JSON MODEL». Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.
1. В качестве решения задания приведите листинг этого файла.

### Ответ:
[Ссылку на json файл прилагаю](../practice/10.2/netology_dashboard.json).

