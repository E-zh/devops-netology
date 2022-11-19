# devops-netology
### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию "6.2. SQL".

### Задача 1.
Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

#### Ответ.
Поднял инстанс PostgresSQL, прилагаю [docker-compose.yml](/practice/06.2-SQL/docker-compose.yml)
```yaml
version: "3"
volumes:
  v-data:
  v-backup:
services:
  postgres:
    image: postgres:12
    container_name: netology_sql
    environment:
      POSTGRES_DB: "netology"
      POSTGRES_USER: "netology"
      POSTGRES_PASSWORD: "netology"
      PGDATA: "/var/lib/postgresql/data/pgdata"
    volumes:
      - v-data:/var/lib/postgresql/data/
      - ./v-backup:/backup
    ports:
      - "5432:5432"
    network_mode: "host"
```

Запускаем и заходим:
```shell
docker-compose up -d
[+] Running 1/1
 ⠿ Container netology_sql  Started
egor@netology:~/postgres$
egor@netology:~/postgres$ docker exec -it netology_sql bash
root@netology:/# psql -U netology -W netology
Password:
psql (12.13 (Debian 12.13-1.pgdg110+1))
Type "help" for help.

netology=#
```

### Задача 2
В БД из задачи 1:

* создайте пользователя test-admin-user и БД test_db
* в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
* предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
* создайте пользователя test-simple-user
* предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:

* id (serial primary key)
* наименование (string)
* цена (integer)

Таблица clients:

* id (serial primary key)
* фамилия (string)
* страна проживания (string, index)
* заказ (foreign key orders)

Приведите:

* итоговый список БД после выполнения пунктов выше,
* описание таблиц (describe)
* SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
* список пользователей с правами над таблицами test_db

#### Ответ:
* Создал пользователя `test-admin-user` и БД `test_db`:
```shell
CREATE DATABASE test_db;
CREATE DATABASE
netology=# CREATE USER "test-admin-user" WITH PASSWORD '12345';
CREATE ROLE
```
* в БД `test_db` создал таблицы `orders` и `clients` по спецификации:
```shell
test_db=# CREATE TABLE orders (id SERIAL PRIMARY KEY, наименование VARCHAR(255), цена INT);
CREATE TABLE
test_db=# CREATE TABLE clients (id SERIAL PRIMARY KEY, фамилия VARCHAR(100), "страна проживания" VARCHAR(50), заказ int REFERENCES orders (id));
CREATE TABLE
```
* предоставил привилегии на все операции пользователю `test-admin-user` на таблицы БД `test_db`:
```shell
netology=# GRANT CONNECT ON DATABASE test_db to "test-admin-user";
GRANT
netology=# GRANT ALL ON ALL TABLES IN SCHEMA public to "test-admin-user";
GRANT
```
* создал пользователя `test-simple-user`:
```shell
netology=# CREATE USER "test-simple-user" WITH PASSWORD '123';
CREATE ROLE
netology=#
```
* предоставил пользователю `test-simple-user` права на `SELECT/INSERT/UPDATE/DELETE` данных таблиц БД `test_db`:
```shell
netology=# GRANT CONNECT ON DATABASE test_db to "test-simple-user";
GRANT
netology=# GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public to "test-simple-user";
GRANT
netology=#
```
* итоговый список БД после выполнения пунктов выше:
```shell
netology=# \l
                                     List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |       Access privileges
-----------+----------+----------+------------+------------+-------------------------------
 netology  | netology | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | netology | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | netology | UTF8     | en_US.utf8 | en_US.utf8 | =c/netology                  +
           |          |          |            |            | netology=CTc/netology
 template1 | netology | UTF8     | en_US.utf8 | en_US.utf8 | =c/netology                  +
           |          |          |            |            | netology=CTc/netology
 test_db   | netology | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/netology                 +
           |          |          |            |            | netology=CTc/netology        +
           |          |          |            |            | "test-admin-user"=c/netology +
           |          |          |            |            | "test-simple-user"=c/netology
(5 rows)

netology=#
```
* описание таблиц (describe), предварительно выбрав БД командой `\c test_db`:
```shell
test_db=# \d orders
                                       Table "public.orders"
    Column    |          Type          | Collation | Nullable |              Default
--------------+------------------------+-----------+----------+------------------------------------
 id           | integer                |           | not null | nextval('orders_id_seq'::regclass)
 наименование | character varying(255) |           |          |
 цена         | integer                |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

test_db=# \d clients
                                         Table "public.clients"
      Column       |          Type          | Collation | Nullable |               Default

-------------------+------------------------+-----------+----------+------------------------------------
-
 id                | integer                |           | not null | nextval('clients_id_seq'::regclass)
 фамилия           | character varying(100) |           |          |
 страна проживания | character varying(50)  |           |          |
 заказ             | integer                |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

test_db=#
```
* SQL-запрос для выдачи списка пользователей с правами над таблицами test_db:
```shell
SELECT grantee, table_name, privilege_type FROM information_schema.table_privileges WHERE grantee LIKE 'test%';
```  
или можно двумя запросами, по каждой таблице отдельно:  
```shell
SELECT table_name, grantee, privilege_type FROM information_schema.role_table_grants WHERE table_name='orders';
SELECT table_name, grantee, privilege_type FROM information_schema.role_table_grants WHERE table_name='clients';
```
* список пользователей с правами над таблицами test_db:  
первым запросом:   
```shell
test_db=# SELECT grantee, table_name, privilege_type FROM information_schema.table_privileges WHERE grantee LIKE 'test%';
     grantee      | table_name | privilege_type
------------------+------------+----------------
 test-admin-user  | orders     | INSERT
 test-admin-user  | orders     | SELECT
 test-admin-user  | orders     | UPDATE
 test-admin-user  | orders     | DELETE
 test-admin-user  | orders     | TRUNCATE
 test-admin-user  | orders     | REFERENCES
 test-admin-user  | orders     | TRIGGER
 test-admin-user  | clients    | INSERT
 test-admin-user  | clients    | SELECT
 test-admin-user  | clients    | UPDATE
 test-admin-user  | clients    | DELETE
 test-admin-user  | clients    | TRUNCATE
 test-admin-user  | clients    | REFERENCES
 test-admin-user  | clients    | TRIGGER
 test-simple-user | orders     | INSERT
 test-simple-user | orders     | SELECT
 test-simple-user | orders     | UPDATE
 test-simple-user | orders     | DELETE
 test-simple-user | clients    | INSERT
 test-simple-user | clients    | SELECT
 test-simple-user | clients    | UPDATE
 test-simple-user | clients    | DELETE
(22 rows)
```  
и вывод информации непосредственно по таблицам отдельными запросами:  
```shell
test_db=# SELECT table_name, grantee, privilege_type FROM information_schema.role_table_grants WHERE table_name='orders';
 table_name |     grantee      | privilege_type
------------+------------------+----------------
 orders     | netology         | INSERT
 orders     | netology         | SELECT
 orders     | netology         | UPDATE
 orders     | netology         | DELETE
 orders     | netology         | TRUNCATE
 orders     | netology         | REFERENCES
 orders     | netology         | TRIGGER
 orders     | test-simple-user | INSERT
 orders     | test-simple-user | SELECT
 orders     | test-simple-user | UPDATE
 orders     | test-simple-user | DELETE
 orders     | test-admin-user  | INSERT
 orders     | test-admin-user  | SELECT
 orders     | test-admin-user  | UPDATE
 orders     | test-admin-user  | DELETE
 orders     | test-admin-user  | TRUNCATE
 orders     | test-admin-user  | REFERENCES
 orders     | test-admin-user  | TRIGGER
(18 rows)

test_db=# SELECT table_name, grantee, privilege_type FROM information_schema.role_table_grants WHERE table_name='clients';
 table_name |     grantee      | privilege_type
------------+------------------+----------------
 clients    | netology         | INSERT
 clients    | netology         | SELECT
 clients    | netology         | UPDATE
 clients    | netology         | DELETE
 clients    | netology         | TRUNCATE
 clients    | netology         | REFERENCES
 clients    | netology         | TRIGGER
 clients    | test-simple-user | INSERT
 clients    | test-simple-user | SELECT
 clients    | test-simple-user | UPDATE
 clients    | test-simple-user | DELETE
 clients    | test-admin-user  | INSERT
 clients    | test-admin-user  | SELECT
 clients    | test-admin-user  | UPDATE
 clients    | test-admin-user  | DELETE
 clients    | test-admin-user  | TRUNCATE
 clients    | test-admin-user  | REFERENCES
 clients    | test-admin-user  | TRIGGER
(18 rows)
```  

### Задача 3.
Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:  

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

#### Ответ:
* Наполняем таблицу `orders`:
```shell
INSERT INTO orders (наименование, цена) VALUES ('Шоколад', 10), ('Принтер', 3000), ('Книга', 500), ('Монитор', 7000), ('Гитара', 4000);
```  
* Наполняем таблицу `clients`:
```shell
INSERT INTO clients (фамилия, "страна проживания") VALUES ('Иванов Иван Иванович', 'USA'), ('Петров Петр Петрович', 'Canada'), ('Иоганн Себастьян Бах', 'Japan'), ('Ронни Джеймс Дио', 'Russia'), ('Ritchie Blackmore', 'Russia');
```

* Количество записей в таблице `orders`:
```shell
test_db=# SELECT count(*) FROM orders;
 count
-------
     5
(1 row)
```  
* Количество записей в таблице `clients`:  
```shell
test_db=# SELECT count(*) FROM clients;
 count
-------
     5
(1 row)
```

### Задача 4.
Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказка - используйте директиву `UPDATE`.

#### Ответ:
* Связал записи из таблицы `clients` таким образом:
```shell
UPDATE clients SET заказ = (SELECT id FROM orders WHERE наименование = 'Книга') WHERE фамилия = 'Иванов Иван Иванович';
UPDATE clients SET заказ = (SELECT id FROM orders WHERE наименование = 'Монитор') WHERE фамилия = 'Петров Петр Петрович';
UPDATE clients SET заказ = (SELECT id FROM orders WHERE наименование = 'Гитара') WHERE фамилия = 'Иоганн Себастьян Бах';
```
* SQL запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса, предлагаю 2 варианта:
  * первый вариант, т.к. мы знаем о столбце `заказ`, что у клиентов совершивших заказ значение этого поля не пустое: 
    ```shell
    test_db=# SELECT * FROM clients WHERE заказ IS NOT NULL;
     id |       фамилия        | страна проживания | заказ
    ----+----------------------+-------------------+-------
      1 | Иванов Иван Иванович | USA               |     3
      2 | Петров Петр Петрович | Canada            |     4
      3 | Иоганн Себастьян Бах | Japan             |     5
    (3 rows)
    ```
  * второй вариант, сложный запрос (также включил в вывод значения столбца `наименование` из таблицы `orders`):
    ```shell
    test_db=# SELECT c.id, c.фамилия, c."страна проживания", c.заказ, o.наименование FROM clients AS c INNER JOIN orders AS o ON o.id = c.заказ;
     id |       фамилия        | страна проживания | заказ | наименование
    ----+----------------------+-------------------+-------+--------------
      1 | Иванов Иван Иванович | USA               |     3 | Книга
      2 | Петров Петр Петрович | Canada            |     4 | Монитор
      3 | Иоганн Себастьян Бах | Japan             |     5 | Гитара
    (3 rows)
    ```  
    
### Задача 5.
Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

#### Ответ:
В решении этого задания взял результаты выполнения сложного запроса:
```shell
test_db=# EXPLAIN SELECT c.id, c.фамилия, c."страна проживания", c.заказ, o.наименование FROM clients AS c INNER JOIN orders AS o ON o.id = c.заказ;
                               QUERY PLAN
-------------------------------------------------------------------------
 Hash Join  (cost=13.15..25.81 rows=210 width=860)
   Hash Cond: (c."заказ" = o.id)
   ->  Seq Scan on clients c  (cost=0.00..12.10 rows=210 width=344)
   ->  Hash  (cost=11.40..11.40 rows=140 width=520)
         ->  Seq Scan on orders o  (cost=0.00..11.40 rows=140 width=520)
(5 rows)
```

Эта команда выводит план выполнения, генерируемый планировщиком PostgreSQL. По каждой операции (итерации) видно стоимость запуска и общую стоимость выполнения. Ожидаемое количество строк и среднюю длину строки в байтах. Строки одной таблицы записываются в хеш-таблицу в памяти, после чего сканируется другая таблица и для каждой её строки проверяется соответствие по хеш-таблице.
По выводу этой команды почитал [материал с сайта PostgresPro](https://postgrespro.ru/docs/postgrespro/9.5/using-explain).

### Задача 6.
Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления.

#### Ответ:
* Создал бэкап БД в volume `backup` с помощью `pg_dumpall`, т.к. нам нужны все данные, включая пользователей:
```shell
root@netology:/# pg_dumpall -U netology -W > /backup/test_db.sql
Password:
```
* Остановил контейнер с PostgreSQL, оставил volume `backup`:
```shell
egor@netology:~/postgres$ docker compose down
[+] Running 1/1
 ⠿ Container netology_sql  Removed                                                                                                                   1.5s
egor@netology:~/postgres$
egor@netology:~/postgres$ docker volume rm postgres_v-data
egor@netology:~/postgres$ docker volume ls
DRIVER    VOLUME NAME
local     postgres_v-backup
```
* Поднял новый пустой контейнер с PostgreSQL:
```shell
egor@netology:~/postgres$ docker-compose up -d
[+] Running 2/2
 ⠿ Volume "postgres_v-data"  Created                                                                                                                 0.3s
 ⠿ Container netology_sql    Started                                                                                                                 4.4s
egor@netology:~/postgres$
```  
* Зашел внутрь контейнера, видим что БД `test_db` отсутствует:
```shell
egor@netology:~/postgres$ docker exec -it netology_sql bash
root@netology:/# psql -U netology -W
Password:
psql (12.13 (Debian 12.13-1.pgdg110+1))
Type "help" for help.

netology=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 netology  | netology | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | netology | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | netology | UTF8     | en_US.utf8 | en_US.utf8 | =c/netology          +
           |          |          |            |            | netology=CTc/netology
 template1 | netology | UTF8     | en_US.utf8 | en_US.utf8 | =c/netology          +
           |          |          |            |            | netology=CTc/netology
(4 rows)

netology=#
```
* Восстановил БД `test_db` в новом контейнере (лог восстановления не привожу, получился довольно длинный):
```shell
root@netology:/# psql -U netology -W -f /backup/test_db.sql
root@netology:/# psql -U netology -W
Password:
psql (12.13 (Debian 12.13-1.pgdg110+1))
Type "help" for help.

netology=# \l
                                     List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |       Access privileges
-----------+----------+----------+------------+------------+-------------------------------
 netology  | netology | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | netology | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | netology | UTF8     | en_US.utf8 | en_US.utf8 | =c/netology                  +
           |          |          |            |            | netology=CTc/netology
 template1 | netology | UTF8     | en_US.utf8 | en_US.utf8 | =c/netology                  +
           |          |          |            |            | netology=CTc/netology
 test_db   | netology | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/netology                 +
           |          |          |            |            | netology=CTc/netology        +
           |          |          |            |            | "test-admin-user"=c/netology +
           |          |          |            |            | "test-simple-user"=c/netology
(5 rows)
```
* Запросил содержимое таблиц `clients` и `orders`, как видим данные восстановлены:
```shell
netology=# \c test_db
Password:
You are now connected to database "test_db" as user "netology".
test_db=# SELECT * FROM clients;
 id |       фамилия        | страна проживания | заказ
----+----------------------+-------------------+-------
  4 | Ронни Джеймс Дио     | Russia            |
  5 | Ritchie Blackmore    | Russia            |
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(5 rows)
test_db=# SELECT * FROM orders;
 id | наименование | цена
----+--------------+------
  1 | Шоколад      |   10
  2 | Принтер      | 3000
  3 | Книга        |  500
  4 | Монитор      | 7000
  5 | Гитара       | 4000
(5 rows)
```