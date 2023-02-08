# devops-netology
### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию "8.4. Работа с roles"

## Подготовка к выполнению
1. (Необязательно) Познакомтесь с [lighthouse](https://youtu.be/ymlrNlaHzIY?t=929)
2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
3. Добавьте публичную часть своего ключа к своему профилю в github.

### Ответ:
Подготовка к выполнению проведена. Создал репозитории для ролей:
* [vector-role](https://github.com/E-zh/vector-role)
* [lighthouse-role](https://github.com/E-zh/lighthouse-role)
* [nginx-role](https://github.com/E-zh/nginx-role)

## Основная часть

Наша основная цель - разбить наш playbook на отдельные roles. Задача: сделать roles для clickhouse, vector и lighthouse и написать playbook для использования этих ролей. Ожидаемый результат: существуют три ваших репозитория: два с roles и один с playbook.

1. Создать в старой версии playbook файл `requirements.yml` и заполнить его следующим содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.11.0"
       name: clickhouse 
   ```

2. При помощи `ansible-galaxy` скачать себе эту роль.
3. Создать новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Описать в `README.md` обе роли и их параметры.
7. Повторите шаги 3-6 для lighthouse. Помните, что одна роль должна настраивать один продукт.
8. Выложите все roles в репозитории. Проставьте тэги, используя семантическую нумерацию. Добавьте roles в `requirements.yml` в playbook.
9. Переработайте playbook на использование roles. Не забудьте про зависимости lighthouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответ приведите ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

---

### Ответ:
1. Создал файл `requirements.yml`, заполнил вышеуказанным содержимым.
2. Скачал роль при помощи `ansible-galaxy`:
   ```shell
   egor@netology:~/Homeworks/08.4/ansible$ ansible-galaxy install -r requirements.yml -p roles
   Starting galaxy role install process
   - extracting clickhouse-role to /home/egor/Homeworks/08.4/ansible/roles/clickhouse-role
   - clickhouse-role (1.11.0) was installed successfully
   ```
3. Создал новые каталоги для ролей `vector`, `lighthouse` и `nginx` с помощью `ansible-galaxy role init`.
4. Перенес данные из старого playbook, разнес переменные между `vars` и `default`.
5. Перенес нужные шаблоны конфигов в `templates`.
6. Описал в `README.md` каждой роли их параметры.
7. Повторил все шаги для всех ролей.
8. Выложил все roles в репозитории. Проставил тэги, используя семантическую нумерацию. Добавил roles в `requirements.yml` в playbook.
9. Переработал playbook на использование roles.
10. [Playbook разместил в этом же репозитории](../practice/08.4/ansible).
11. Все свои созданные роли разместил в этих репозиториях:
    * [vector-role](https://github.com/E-zh/vector-role)
    * [lighthouse-role](https://github.com/E-zh/lighthouse-role)
    * [nginx-role](https://github.com/E-zh/nginx-role)
