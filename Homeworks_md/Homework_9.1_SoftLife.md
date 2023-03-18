# devops-netology
### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию "9.1. Жизненный цикл ПО"

## Подготовка к выполнению
1. Получить бесплатную [JIRA](https://www.atlassian.com/ru/software/jira/free)
2. Настроить её для своей "команды разработки"
3. Создать доски kanban и scrum

### Ответ:
1. Зарегистрировался в бесплатной [JIRA](https://www.atlassian.com/ru/software/jira/free).
2. Настроил, создал проект `dev-netology`.
3. Создал доски доски kanban и scrum в проекте `dev-netology`:  
    ![](../pics/9.1/created_boards.jpg)  

## Основная часть
В рамках основной части необходимо создать собственные workflow для двух типов задач: bug и остальные типы задач. Задачи типа bug должны проходить следующий жизненный цикл:
1. Open -> On reproduce
2. On reproduce -> Open, Done reproduce
3. Done reproduce -> On fix
4. On fix -> On reproduce, Done fix
5. Done fix -> On test
6. On test -> On fix, Done
7. Done -> Closed, Open

Остальные задачи должны проходить по упрощённому workflow:
1. Open -> On develop
2. On develop -> Open, Done develop
3. Done develop -> On test
4. On test -> On develop, Done
5. Done -> Closed, Open

Создать задачу с типом bug, попытаться провести его по всему workflow до Done. Создать задачу с типом epic, к ней привязать несколько задач с типом task, провести их по всему workflow до Done. При проведении обеих задач по статусам использовать kanban. Вернуть задачи в статус Open.
Перейти в scrum, запланировать новый спринт, состоящий из задач эпика и одного бага, стартовать спринт, провести задачи до состояния Closed. Закрыть спринт.

Если всё отработало в рамках ожидания - выгрузить схемы workflow для импорта в XML. Файлы с workflow приложить к решению задания.

### Ответ:
1. Для проекта `dev-netology` создал 2 workflow:  
    ![](../pics/9.1/List_workflows.jpg)
2. Диаграмма `Bug workflow`:
    ![](../pics/9.1/Bug_workflow_diagram.jpg)  
3. Диаграмма `All tasks worflow`:
    ![](../pics/9.1/Alltasks_worflow_diagram.jpg)  
4. Также прилагаю настройки досок Kanban и Scrum:
    ![](../pics/9.1/kanban_settings.jpg)
    ![](../pics/9.1/scrum_settings.jpg)  
5. Выполнил все действия из обязательной задачи, выгрузил схемы workflow в XML:
    * [All tasks worflow](../practice/09.1/All_tasks_worflow.xml)
    * [Bug workflow](../practice/09.1/Bug_workflow.xml)
    