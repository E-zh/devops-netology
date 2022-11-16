# devops-netology
### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию «2.4. Инструменты Git»

1) Полный хеш коммита - `aefead2207ef7e2aa5dc81a34aedf0cad4c32545`

    Комментарий - `Update CHANGELOG.md`

    Получено командой: `git show aefea`

2) Коммит `85024d3` соответствует тегу `v0.12.23`
    
    Получено командой: `git show -s 85024d3 --oneline`

3) У коммита `b8d720` 2 родителя.

    Хеши `56cd7859e05c36c06b56d013b55a252d0bb7e158` и `9ea88f22fc6269854151c571162c5bcf958bee2b`
    
    Результат получен командой: `git show --pretty=format:"%P" b8d720`

4) хеши и комментарии всех коммитов которые были сделаны между тегами `v0.12.23 и v0.12.24`:
    `33ff1c03bb960b332be3af2e333462dde88b279e (tag: v0.12.24) v0.12.24`

    `b14b74c4939dcab573326f4e3ee2a62e23e12f89 [Website] vmc provider links`

    `3f235065b9347a758efadc92295b540ee0a5e26e Update CHANGELOG.md`

    `6ae64e247b332925b872447e9ce869657281c2bf registry: Fix panic when server is unreachable`

    `5c619ca1baf2e21a155fcdb4c264cc9e24a2a353 website: Remove links to the getting started guide's old location`

    `06275647e2b53d97d4f0a19a0fec11f6d69820b5 Update CHANGELOG.md`

    `d5f9411f5108260320064349b757f55c09bc4b80 command: Fix bug when using terraform login on Windows`

    `4b6d06cc5dcb78af637bbb19c198faff37a066ed Update CHANGELOG.md`

    `dd01a35078f040ca984cdd349f18d0b67e486c35 Update CHANGELOG.md`

    `225466bc3e5f35baa5d07197bbc079345b77525e Cleanup after v0.12.23 release`

    Получено командой: `git log --pretty=oneline v0.12.23..v0.12.24`

5) Коммит в котором была создана функция `"func providerSource": 8c928e8358`

    Получено командой: `git log -S "func providerSource(" --oneline`

6) Коммит в котором была изменена функция globalPluginDirs: `8364383c35`
    
    Получено командой: `git log -S "func globalPluginDirs(" --oneline`
	
7) Создатель функции `synchronizedWriters` - Martin Atkins <mart@degeneration.co.uk>

    Как получено:
    * Команда выводит два коммита - `git log -S "func synchronizedWriters(" --pretty=format:"%h - %an %ae"`:
    * `bdfea50cc8 - James Bardin j.bardin@gmail.com`
    * `5ac311e2a9 - Martin Atkins mart@degeneration.co.uk`
    * Просмотрев коммит `5ac311e2a9` командой `"git show 5ac311e2a"`, видим, что данная функция создана именно в этом коммите, и его автором является Martin Atkins.
		
#### Задание - объяснить наполнение файла .gitignore

* Этим правилом игнорируются каталоги _.terraform_ в любом месте папки terraform:

  ``**/.terraform/*``
* Знак звездочки может соответствовать как нескольким символам, так и ни одному. В данном случае будут игнорироваться все 
  файлы, оканчивающиеся на _.tfstate_ во всех папках каталога terraform:
  
  ``*.tfstate``
* Данное правило проигнорирует файлы, в имени которых до точки и после точки присутствует _.tfstate._ во всех папках каталога terraform:
  
  ``*.tfstate.*``
* В этих записях, в первом случае явно указан файл _crash.log_ в корне папки terraform, а во втором случае звездочка может быть заменена любым количеством символов. Файлы будут проигнорированы во всех папках каталога terraform:

  ``crash.log``
  ``crash.*.log``

* Эти правила заставят Git проигнорировать файлы с расширением _.tfvars_, а во втором случае звездочка может быть заменена любым количеством символов. Файлы будут проигнорированы во всех папках каталога terraform:

  ``*.tfvars``
  ``*.tfvars.json``
* Следующие записи показывают явно на файлы, которые нужно проигнорировать во всех папках каталога terraform:
  
  ``override.tf``
  ``override.tf.json``
* Эти правила указывают на файлы, которые будут игнорироваться рекурсивно начиная с папки terraform и далее во всех директориях, в именах которых звездочка заменяется любым количеством символов:

  ``*_override.tf``
  ``*_override.tf.json``
* Эти правила указывают на файлы, которые будут игнорироваться рекурсивно начиная с папки terraform и далее во всех директориях:

  ``.terraformrc``
  ``terraform.rc``
