# devops-netology
### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию "6.2. MySQL".

### Задача 1.
Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и восстановитесь из него.

Перейдите в управляющую консоль mysql внутри контейнера.

Используя команду \h получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с price > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

#### Ответ:
* поднял инстанс MySQL 8-й версии, прилагаю [docker-compose.yml](/practice/06.3-MySQL/docker-compose.yml). Также дополнительно подключил volume `backup`, куда положил файл дампа БД.
```yaml
version: '3.8'
services:
  db:
    image: mysql:8.0
    container_name: netology_mysql
    restart: always
    environment:
      - MYSQL_DATABASE=test_db
      - MYSQL_ROOT_PASSWORD=netology
    ports:
      - '3306:3306'
    volumes:
      - ./db:/var/lib/mysql
      - ./backup:/backup
```
* Восстановил базу данных из бэкапа:
```shell
bash-4.4# mysql -u root -pnetology test_db < /backup/test_dump.sql
mysql: [Warning] Using a password on the command line interface can be insecure.
bash-4.4#
```
* С помощью команды `\h` получил список управляющих команд:
```shell
mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.
query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.
ssl_session_data_print Serializes the current SSL session data to stdout or file

For server side help, type 'help contents'
```
* Команда для выдачи статуса БД - `\s` или `status`, вывод команды (версия сервера БД - 8.0.31):
```shell
mysql> \s
--------------
mysql  Ver 8.0.31 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          11
Current database:       test_db
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.31 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb3
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 5 min 9 sec

Threads: 2  Questions: 49  Slow queries: 0  Opens: 161  Flush tables: 3  Open tables: 79  Queries per second avg: 0.158
--------------
```
* Подключился к восстановленной БД и получил список таблиц из этой БД:
```shell
mysql> use test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)
```
* Количество записей с `price > 300`:
```shell
mysql> SELECT COUNT(*) FROM orders WHERE price > 300;
+----------+
| COUNT(*) |
+----------+
|        1 |
+----------+
1 row in set (0.01 sec)
```
* И соответственно сами записи по условию выше (если нужно):
```shell
mysql> SELECT * FROM orders WHERE price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)
```

### Задача 2.
Создайте пользователя test в БД c паролем test-pass, используя:

- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней
- количество попыток авторизации - 3
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"
Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.

Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test и **приведите в ответе к задаче.**

#### Ответ:
* Создание пользователя по вышеуказанным параметрам:
```shell
mysql> create user 'test'@'localhost'
    ->     identified with mysql_native_password by 'test-pass'
    ->     with max_queries_per_hour 100
    ->     password expire interval 180 day
    ->     failed_login_attempts 3
    ->     attribute '{"fname": "James","lname": "Pretty"}';
Query OK, 0 rows affected (0.40 sec)
```
* Предоставил привилегии пользователю `test` на операции SELECT базы `test_db`:
```shell
mysql> grant SELECT on test_db.* to 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.45 sec)
mysql> flush privileges;
Query OK, 0 rows affected (0.13 sec)
```
* Используя таблицу `INFORMATION_SCHEMA.USER_ATTRIBUTES` получил данные по пользователю `test`:
```shell
mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES where user='test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)
```

### Задача 3.
Установите профилирование `SET profiling = 1`. Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе.**

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе:**

- на MyISAM
- на InnoDB

#### Ответ:
* Установил профилирование `SET profiling = 1` и выполнил команду `SHOW PROFILES;`:
```shell
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)
mysql> SHOW PROFILES;
+----------+------------+-----------------------------------------------+
| Query_ID | Duration   | Query                                         |
+----------+------------+-----------------------------------------------+
|        1 | 0.00280225 | show tables                                   |
|        2 | 0.00068400 | SELECT COUNT(*) FROM orders WHERE price > 300 |
|        3 | 0.00059750 | SELECT * FROM orders WHERE price > 300        |
|        4 | 0.00022000 | SET profiling = 1                             |
+----------+------------+-----------------------------------------------+
4 rows in set, 1 warning (0.00 sec)
```
* Информация о `engine` таблицы `orders` (в нашем случае - `InnoDB`):
```shell
mysql> SHOW TABLE STATUS WHERE Name = 'orders';
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| Name   | Engine | Version | Row_format | Rows | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time         | Update_time         | Check_time | Collation          | Checksum | Create_options | Comment |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| orders | InnoDB |      10 | Dynamic    |    5 |           3276 |       16384 |               0 |            0 |         0 |              6 | 2022-11-26 10:48:59 | 2022-11-26 10:49:03 | NULL       | utf8mb4_0900_ai_ci |     NULL |                |         |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
1 row in set (0.00 sec)
```
* Меняем `engine` на `MyISAM` и обратно на `InnoDB`, также выполним пару запросов, и выводим результат выполнения `SHOW PROFILES;` еще раз:
```shell
mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (2.88 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM orders;
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  1 | War and Peace         |   100 |
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
5 rows in set (0.00 sec)

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (2.83 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM orders;
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  1 | War and Peace         |   100 |
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
5 rows in set (0.00 sec)

mysql> SHOW PROFILES;
+----------+------------+-----------------------------------------------+
| Query_ID | Duration   | Query                                         |
+----------+------------+-----------------------------------------------+
|        1 | 0.00280225 | show tables                                   |
|        2 | 0.00068400 | SELECT COUNT(*) FROM orders WHERE price > 300 |
|        3 | 0.00059750 | SELECT * FROM orders WHERE price > 300        |
|        4 | 0.00022000 | SET profiling = 1                             |
|        5 | 0.00330500 | SHOW TABLE STATUS WHERE Name = 'orders'       |
|        6 | 2.87885950 | ALTER TABLE orders ENGINE = MyISAM            |
|        7 | 0.00058775 | SELECT * FROM orders                          |
|        8 | 2.83435025 | ALTER TABLE orders ENGINE = InnoDB            |
|        9 | 0.00063225 | SELECT * FROM orders                          |
+----------+------------+-----------------------------------------------+
9 rows in set, 1 warning (0.00 sec)
```
* Из вывода команды `SHOW PROFILES;` видно, что выборка из БД на `InnoDB` выполняется дольше, чем на `MyISAM`.

### Задача 4.
Изучите файл `my.cnf` в директории `/etc/mysql`.

Измените его согласно ТЗ (движок InnoDB):

- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб
Приведите в ответе измененный файл `my.cnf`.

#### Ответ:
* Изменения для файла `my.cnf` согласно вышеуказанного ТЗ:
```shell
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M

# Remove leading # to revert to previous value for default_authentication_plugin,
# this will increase compatibility with older clients. For background, see:
# https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_authentication_plugin
# default-authentication-plugin=mysql_native_password
skip-host-cache
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/run/mysqld/mysqld.sock
secure-file-priv=/var/lib/mysql-files
user=mysql
pid-file=/var/run/mysqld/mysqld.pid

# Скорость IO важнее сохранности данных:
innodb_flush_log_at_trx_commit = 2
# Компрессия таблиц для экономии места на диске:
innodb_file_per_table = 1
# Размер буффера с незакомиченными транзакциями 1 Мб:
innodb_log_buffer_size = 1M
# Буффер кеширования 30% от ОЗУ:
innodb_buffer_pool_size = 2458M
# Размер файла логов операций 100 Мб:
innodb_log_file_size = 100M

[client]
socket=/var/run/mysqld/mysqld.sock

!includedir /etc/mysql/conf.d/
```