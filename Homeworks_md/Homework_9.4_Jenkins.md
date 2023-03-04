# devops-netology
### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию "09.4. Jenkins"

## Подготовка к выполнению

1. Создать 2 VM: для jenkins-master и jenkins-agent.
2. Установить jenkins при помощи playbook'a.
3. Запустить и проверить работоспособность.
4. Сделать первоначальную настройку.

### Ответ:
1. Создал 2 виртуальные машины с помощью `terraform`, [файл main.tf](../practice/09.4/terraform/main.tf) прилагаю.
2. Установил jenkins при помощи playbook'a (лог не маленький, привожу скриншот концовки):
    ![](../pics/9.4/ansible-playbook_install_jenkins.jpg)  
3. в браузере перешел по адресу `http://158.160.63.204:8080`, разблокировал и установил плагины:
    ![](../pics/9.4/url_jenkins.jpg)  
4. Произвел первоначальную настройку, добавил агент `agent-nelology`, ввиду того что в способе запуска агента у меня отсутствовал пункт `launch agent via execution of command on the controller`, и победить это я не смог, настроил запуск на `Launch agent by connected it to the controller`:
    ![](../pics/9.4/start_jenkins.jpg)  


## Основная часть

1. Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
2. Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.
4. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.
5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](../practice/09.4/pipeline).
6. Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True), по умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.
7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`.
8. Отправить ссылку на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline.

### Ответ:
1. Создал Freestyle Job с именем `freestyle-netology`:
    - <details><summary>Скриншот настроек freestyle-netology</summary>

        ![Настройки freestyle проекта](../pics/9.4/free_job_settings.jpg)

      </details>  
    Результат выполнения:  
    ![](../pics/9.4/free_job_result.jpg)
2. Создал Declarative Pipeline Job с именем `declarative-netology`:
    - <details><summary>Скриншот настроек declarative-netology</summary>

        ![Настройки freestyle проекта](../pics/9.4/declarative_job_settings.jpg)

      </details>  
    Результат выполнения:  
    ![](../pics/9.4/declarative_job_result.jpg)  
    Содержимое скрипта также прилагаю в [файле declarative_pipeline](../practice/09.4/jenkins/declarative_pipeline).
3. Перенас Declarative Pipeline в репозиторий в [файл Jenkinsfile](https://github.com/E-zh/vector-role/blob/main/Jenkinsfile).
4. Создал Multibranch Pipeline на запуск `Jenkinsfile` из репозитория с именем `multibranch-netology`:
    - <details><summary>Скриншот лог сканирования multibranch-netology</summary>

        ![Результат сканирования](../pics/9.4/multibranch_job_scan.jpg)

      </details>
    - <details><summary>Скриншот настроек multibranch-netology</summary>

        ![Результат сканирования](../pics/9.4/multibranch_job_settings.jpg)

      </details>
    Результат выполнения:  
    ![](../pics/9.4/multibranch_job_result.jpg)  
5. Создал Scripted Pipeline, наполнил его скриптом из [pipeline](https://github.com/netology-code/mnt-homeworks/blob/MNT-video/09-ci-04-jenkins/pipeline/Jenkinsfile).  
6. Настроил проект, внес изменения:  
    ![](../pics/9.4/scripted_pipeline_set.jpg)  
7. Результат выполнения, запускал с параметром `prod_run` и без него:
    ![](../pics/9.4/scripted_pipeline_result.jpg)  
8. Прилагаю ссылки на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline:
    * [Declarative Pipeline](https://github.com/E-zh/vector-role/)
    * Scripted Pipeline, [файл ScriptedJenkinsfile](../practice/09.4/jenkins/ScriptedJenkinsfile)
