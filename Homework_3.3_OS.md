# devops-netology

## HomeWork 3.3
### Желобанов Егор DEVOPS-21

1. Системный вызов, который относится к команде `cd` - `chdir("/tmp")`.
2. База данных `file` находится здесь: `/usr/share/misc/magic.mgc`. Также, возможно поиск осуществляется и здесь:
   - `/home/vagrant/.magic.mgc`
   - `/home/vagrant/.magic`
   - `/etc/magic.mgc`
   - `/etc/magic`
3. Выполнял с текстовым редактором `nano`. Определим `PID` процесса, в моем случае это `1055`, получено командой `pstree -p | grep nano`. Далее узнаем дескриптор файла
командой `lsof -p 1055`, получил - `9`. Далее командой `echo` запишем в файл по его дескриптору пустое значение, удаляя его содержимое: `echo '' > /proc/1055/fd/9`.
4. Зомби-процессы освобождают свои ресурсы, но не освобождают запись в таблице процессов.
5. Вывод команды `sudo opensnoop-bpfcc` в первую секунду работы: 
```shell
vagrant@vagrant:~$ sudo opensnoop-bpfcc
PID    COMM               FD ERR PATH
631    irqbalance          6   0 /proc/interrupts
631    irqbalance          6   0 /proc/stat
631    irqbalance          6   0 /proc/irq/20/smp_affinity
631    irqbalance          6   0 /proc/irq/0/smp_affinity
631    irqbalance          6   0 /proc/irq/1/smp_affinity
631    irqbalance          6   0 /proc/irq/8/smp_affinity
631    irqbalance          6   0 /proc/irq/12/smp_affinity
631    irqbalance          6   0 /proc/irq/14/smp_affinity
631    irqbalance          6   0 /proc/irq/15/smp_affinity
372    systemd-udevd      14   0 /sys/fs/cgroup/unified/system.slice/systemd-udevd.service/cgroup.procs
372    systemd-udevd      14   0 /sys/fs/cgroup/unified/system.slice/systemd-udevd.service/cgroup.threads
810    vminfo              4   0 /var/run/utmp
626    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
626    dbus-daemon        21   0 /usr/share/dbus-1/system-services
626    dbus-daemon        -1   2 /lib/dbus-1/system-services
626    dbus-daemon        21   0 /var/lib/snapd/dbus-1/system-services/
1      systemd            12   0 /proc/646/cgroup
1      systemd            12   0 /proc/602/cgroup
810    vminfo              4   0 /var/run/utmp
626    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
```
6. Команда `uname -a` использует системный вызов `uname()`, что указано в `man`, цитата:  
> Part of the utsname information is also accessible via `/proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}`.
7. Символ `;` - это разделитель команд, в этом случае вторая команда отработает при любом статусе завершения первой. 
В случае использования условного оператора `&&` - вторая команда не будет выполнена, если первая завершится с ошибкой. 
С `set -e` произойдет выход из шелла при любом ненулевом коде возврата команды, но если одна из команд, разделенных условным оператором `&&` завершится с ошибкой, то выхода из шелла не произойдет.
8. Режим `bash set -euxo pipefail` состоит из следующих опций:
   - `-u` - сценарий завершится, при попытке использовать незаданную переменную;
   - `-x` - выведет команды и их аргументы по мере выполнения;
   - `-e` - сценарий завершится при завершении команды с ненулевым статусом;
   - `-o pipefail` - вернет статус последней команды с ошибкой в пайплайне;  
Данный режим хорошо подходит для использования в сценариях, потому что:
   - `-u` выявит, если какая-то переменная не задана; 
   - `-x` подробно отобразит работу сценария;
   - `-e` с `pipefail` обнаружат и отобразят на какой именно команде произошла ошибка сценария.
9. Наиболее часто встречающийся статус у процессов в системе:
   - `S`: прерываемый сон (ожидание завершения события);
   - `I`: фоновые(бездействующие) процессы ядра.  
Дополнительные, к основной заглавной букве статуса процессов символы:
   - `<` - процесс с высоким приоритетом;
   - `N` - процесс с низким приоритетом;
   - `L` - процесс имеет страницы, заблокированные в памяти;
   - `s` - процесс инициатор сессии;
   - `l` - процесс является многопоточным;
   - `+` - процесс находится в группе процессов переднего плана.