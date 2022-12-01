# devops-netology
### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию "6.4. PostgreSQL".

### Задача 1.
Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:

- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

#### Ответ:
* поднял инстанс PostgreSQL 13-й версии, прилагаю [docker-compose.yml](/practice/06.4-PostgreSQL/docker-compose.yml). Также дополнительно подключил volume `backup`, куда положил файл дампа БД:
```yaml
version: "3"
volumes:
  p-data:
  p-backup:
services:
  postgres:
    image: postgres:13
    container_name: netology_psql
    environment:
      POSTGRES_DB: "netology"
      POSTGRES_USER: "netology"
      POSTGRES_PASSWORD: "netology"
      PGDATA: "/var/lib/postgresql/data/pgdata"
    volumes:
      - p-data:/var/lib/postgresql/data/
      - p-backup:/backup
    ports:
      - "5432:5432"
    network_mode: "host"

```
* Подключился к БД PostgreSQL используя `psql`:
```shell
root@netology:/backup# psql -U netology -W netology
Password:
psql (13.9 (Debian 13.9-1.pgdg110+1))
Type "help" for help.

netology=#
```
* С помощью команды `\?` вывел подсказки по имеющимся в psql управляющим командам:
    - вывод списка БД - `\l`
    - подключение к БД - `\c`, с параметрами `\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}`
    - вывод списка таблиц - `\dt[S+] [PATTERN]`
    - вывод описания содержимого таблиц - `\d[S+]  NAME`
    - выход из psql - `\q`


### Задача 2.
Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу pg_stats, найдите столбец таблицы `orders` с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.


#### Ответ:
* Создал БД `test_database`, видим что БД успешно создалась:
```shell
netology=# CREATE DATABASE test_database;
CREATE DATABASE
netology-# \l
                                   List of databases
     Name      |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
---------------+----------+----------+------------+------------+-----------------------
 netology      | netology | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres      | netology | UTF8     | en_US.utf8 | en_US.utf8 |
 template0     | netology | UTF8     | en_US.utf8 | en_US.utf8 | =c/netology          +
               |          |          |            |            | netology=CTc/netology
 template1     | netology | UTF8     | en_US.utf8 | en_US.utf8 | =c/netology          +
               |          |          |            |            | netology=CTc/netology
 test_database | netology | UTF8     | en_US.utf8 | en_US.utf8 |
(5 rows)
```
* Изучил бэкап БД, предварительно положил его в volume `p-backup`.
* Восстановил бэкап БД в `test_database`:
```shell
root@netology:/# psql -U netology -f /backup/test_dump.sql test_database
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
```
* Перешел в управляющую консоль `psql`:
```shell
root@netology:/# psql -U netology -W netology
psql (13.9 (Debian 13.9-1.pgdg110+1))
Type "help" for help.
```
* Подключился к восстановленной БД и провел операцию `ANALYZE` для сбора статистики по таблице:
```shell
netology=# \c test_database
Password:
You are now connected to database "test_database" as user "netology".
test_database=#
test_database=# ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
test_database=#
```
* Используя таблицу pg_stats, нашел столбец таблицы `orders` с наибольшим средним значением размера элементов в байтах:
```shell
test_database=# SELECT avg_width FROM pg_stats WHERE tablename='orders';
 avg_width
-----------
         4
        16
         4
(3 rows)
```

### Задача 3.
Архитектор и администратор БД выяснили, что ваша таблица `orders` разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы `orders`?

#### Ответ:
* Да, можно было избежать разбиения таблицы вручную, нужно было определить тип таблицы `partitioned table` в самом начале, в момент проектирования и создания базы данных.
* SQL-транзакция для проведения данной операции:
```shell
begin;
    create table orders_new (
        id integer NOT NULL,
        title varchar(100) NOT NULL,
        price integer) partition by range(price);
    create table orders_1 partition of orders_new for values from (0) to (499);
    create table orders_2 partition of orders_new for values from (499) to (99999);
    insert into orders_new (id, title, price) select * from orders;
commit;
```
* Результат выполнения:
```shell
test_database=# begin;
    create table orders_new (
        id integer NOT NULL,
        title varchar(100) NOT NULL,
        price integer) partition by range(price);
    create table orders_1 partition of orders_new for values from (0) to (499);
    create table orders_2 partition of orders_new for values from (499) to (99999);
    insert into orders_new (id, title, price) select * from orders;
commit;
BEGIN
CREATE TABLE
CREATE TABLE
CREATE TABLE
INSERT 0 8
COMMIT
test_database=# \d
                   List of relations
 Schema |     Name      |       Type        |  Owner
--------+---------------+-------------------+----------
 public | orders        | table             | netology
 public | orders_1      | table             | netology
 public | orders_2      | table             | netology
 public | orders_id_seq | sequence          | netology
 public | orders_new    | partitioned table | netology
(5 rows)

test_database=#
```

### Задача 4.
Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?


#### Ответ:
* Используя утилиту `pg_dump` создал бекап БД `test_database`:
```shell
root@netology:/# pg_dump -U netology -W test_database > /backup/test_database.sql
Password:
root@netology:/#
```
* Для добавления уникальности значения столбца `title` таблиц БД `test_databases`, можно добавить запросы в файл бэкапа:
```shell
ALTER TABLE public.orders ADD CONSTRAINT unique_orders_title UNIQUE (title);
ALTER TABLE public.orders_1 ADD CONSTRAINT unique_orders_1_title UNIQUE (title);
ALTER TABLE public.orders_2 ADD CONSTRAINT unique_orders_2_title UNIQUE (title);
```