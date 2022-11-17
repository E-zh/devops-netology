# devops-netology
### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию "6.1. Типы и структура СУБД".

### Задача 1.
Архитектор ПО решил проконсультироваться у вас, какой тип БД лучше выбрать для хранения определенных данных.

Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:

* Электронные чеки в json виде
* Склады и автомобильные дороги для логистической компании
* Генеалогические деревья
* Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации
* Отношения клиент-покупка для интернет-магазина  

Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.

#### Ответ
* Электронные чеки в json виде - `документо-ориентированная`. Классический подход для хранения документов в json.
* Склады и автомобильные дороги для логистической компании - `графовая` NoSQL БД. Склады и дороги удобно представлять в виде узлов.
* Генеалогические деревья - `иерархическая`, т.к. более ярко выражает класические деревья с одним родителем.
* Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации - `кюч-значение`, идеальный продход для данной задачи, например Redis.
* Отношения клиент-покупка для интернет-магазина - `реляционные`, т.к. в данном случае подходит для создания отношений (зависимостей) между сущностями, например хранить данные о клиенте, о том что покупал, какое кол-во, в какой период и т.п., т.е. мы можем получать общую статистику по действиям клиента.

### Задача 2.
Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если (каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):

* Данные записываются на все узлы с задержкой до часа (асинхронная запись)
* При сетевых сбоях, система может разделиться на 2 раздельных кластера
* Система может не прислать корректный ответ или сбросить соединение  

А согласно PACELC-теореме, как бы вы классифицировали данные реализации?

#### Ответ
* `CA (PC/EL)` - Данные записываются на все узлы с задержкой до часа (асинхронная запись)
* `PA (PA/EL)` - При сетевых сбоях, система может разделиться на 2 раздельных кластера
* `PC (PA/EC)` - Система может не прислать корректный ответ или сбросить соединение

### Задача 3.
Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?

#### Ответ

Не могут. Это два противоречащих друг другу принципа. По `ACID` - данные согласованы, по `BASE` - данные не согласованы. 

### Задача 4.
Вам дали задачу написать системное решение, основой которого бы послужили:

* фиксация некоторых значений с временем жизни
* реакция на истечение таймаута  

Вы слышали о key-value хранилище, которое имеет механизм Pub/Sub. Что это за система? Какие минусы выбора данной системы?

#### Ответ
`Redis` - key-value хранилище, которое имеет механизм Pub/Sub.  
Минусы данной системы:
* Требуются достаточные ресурсы RAM (оперативной памяти)
* Это NoSQL база, возможна проблема оперативного поиска данных
* Все данные храняться в оперативной памяти и при отказе сервера все данные с последней синхронизации с диском будут утеряны