# devops-netology

## HomeWork 3.5
### Желобанов Егор DEVOPS-21

1. Почитал, ознакомился. Было интересно узнать, что разреженные файлы, это файлы, для которых пространство на диске выделяется только для участков с ненулевыми данными, а список всех так называемых "дыр" хранится в метаданных файловой системы и используется при операциях с файлами. В итоге получается, что разреженный файл занимает меньше места на диске. В результате имеем более эффективное использование дискового пространства.
2. Файлы, являющиеся жесткой ссылкой на один объект, не могут иметь разные права доступа и владельца, т.к. они имеют один и тот же inode.
3. Заменил содержимое Vagrantfile нужными данными, поднял виртуальную машину, запустил команду `lsblk`:
    ```shell
    vagrant@vagrant:~$ lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    loop0                       7:0    0 43.6M  1 loop /snap/snapd/14978
    loop1                       7:1    0 61.9M  1 loop /snap/core20/1328
    loop2                       7:2    0 67.2M  1 loop /snap/lxd/21835
    loop3                       7:3    0   62M  1 loop /snap/core20/1611
    loop4                       7:4    0   47M  1 loop /snap/snapd/16292
    loop5                       7:5    0 67.8M  1 loop /snap/lxd/22753
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0  1.5G  0 part /boot
    └─sda3                      8:3    0 62.5G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /
    sdb                         8:16   0  2.5G  0 disk
    sdc                         8:32   0  2.5G  0 disk
    ```
    Новая конфигурация создала новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.
4. Разбил первый диск на разделы с помощью `fdisk`:
    ```shell
    vagrant@vagrant:~$ lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    loop0                       7:0    0 43.6M  1 loop /snap/snapd/14978
    loop1                       7:1    0 61.9M  1 loop /snap/core20/1328
    loop2                       7:2    0 67.2M  1 loop /snap/lxd/21835
    loop3                       7:3    0   62M  1 loop /snap/core20/1611
    loop4                       7:4    0   47M  1 loop /snap/snapd/16292
    loop5                       7:5    0 67.8M  1 loop /snap/lxd/22753
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0  1.5G  0 part /boot
    └─sda3                      8:3    0 62.5G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    └─sdb2                      8:18   0  511M  0 part
    sdc                         8:32   0  2.5G  0 disk
    ```
5. Перенес с помощью `fdisk` таблицу разделов на второй диск:
    ```shell
    vagrant@vagrant:~$ sudo sfdisk -d /dev/sdb | sudo sfdisk /dev/sdc
    Checking that no-one is using this disk right now ... OK
    
    Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
    Disk model: VBOX HARDDISK
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0xbb005864
    
    Old situation:
    
    >>> Script header accepted.
    >>> Script header accepted.
    >>> Script header accepted.
    >>> Script header accepted.
    >>> Created a new DOS disklabel with disk identifier 0x093a367f.
    /dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
    /dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
    /dev/sdc3: Done.
    
    New situation:
    Disklabel type: dos
    Disk identifier: 0x093a367f
    
    Device     Boot   Start     End Sectors  Size Id Type
    /dev/sdc1          2048 4196351 4194304    2G 83 Linux
    /dev/sdc2       4196352 5242879 1046528  511M 83 Linux
    
    The partition table has been altered.
    
    Calling ioctl() to re-read partition table.
    Syncing disks.
    vagrant@vagrant:~$ lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    loop0                       7:0    0 43.6M  1 loop /snap/snapd/14978
    loop1                       7:1    0 61.9M  1 loop /snap/core20/1328
    loop2                       7:2    0 67.2M  1 loop /snap/lxd/21835
    loop3                       7:3    0   62M  1 loop /snap/core20/1611
    loop4                       7:4    0   47M  1 loop /snap/snapd/16292
    loop5                       7:5    0 67.8M  1 loop /snap/lxd/22753
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0  1.5G  0 part /boot
    └─sda3                      8:3    0 62.5G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    └─sdb2                      8:18   0  511M  0 part
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    └─sdc2                      8:34   0  511M  0 part
    ```
6. Собрал RAID1 на паре разделов 2 Гб с помощью `mdadm`:
    ```shell
    vagrant@vagrant:~$ sudo mdadm --create /dev/md0 -l 1 -n 2 /dev/sdb1 /dev/sdc1
    mdadm: Note: this array has metadata at the start and
        may not be suitable as a boot device.  If you plan to
        store '/boot' on this device please ensure that
        your boot-loader understands md/v1.x metadata, or use
        --metadata=0.90
    Continue creating array? y
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md0 started.
    ```
7. Собрал RAID0 на паре маленьких разделов с помощью `mdadm`:
    ```shell
    vagrant@vagrant:~$ sudo mdadm --create /dev/md1 -l 0 -n 2 /dev/sdb2 /dev/sdc2
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md1 started.
    ```
   Запускаем `lsblk`, смотрим:
    ```shell
    vagrant@vagrant:~$ lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    loop0                       7:0    0 43.6M  1 loop  /snap/snapd/14978
    loop1                       7:1    0 61.9M  1 loop  /snap/core20/1328
    loop2                       7:2    0 67.2M  1 loop  /snap/lxd/21835
    loop3                       7:3    0   62M  1 loop  /snap/core20/1611
    loop4                       7:4    0   47M  1 loop  /snap/snapd/16292
    loop5                       7:5    0 67.8M  1 loop  /snap/lxd/22753
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0  1.5G  0 part  /boot
    └─sda3                      8:3    0 62.5G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    │ └─md0                     9:0    0    2G  0 raid1
    └─sdb2                      8:18   0  511M  0 part
      └─md1                     9:1    0 1018M  0 raid0
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    │ └─md0                     9:0    0    2G  0 raid1
    └─sdc2                      8:34   0  511M  0 part
      └─md1                     9:1    0 1018M  0 raid0
    ```
8. Создал 2 независимых PV на получившихся md-устройствах:
   ```shell
   vagrant@vagrant:~$ sudo pvcreate /dev/md0 /dev/md1
   Physical volume "/dev/md0" successfully created.
   Physical volume "/dev/md1" successfully created.
   ```
   Запустим команду `pvscan`:
   ```shell
   vagrant@vagrant:~$ sudo pvscan
   PV /dev/sda3   VG ubuntu-vg       lvm2 [<62.50 GiB / 31.25 GiB free]
   PV /dev/md0                       lvm2 [<2.00 GiB]
   PV /dev/md1                       lvm2 [1018.00 MiB]
   Total: 3 [<65.49 GiB] / in use: 1 [<62.50 GiB] / in no VG: 2 [2.99 GiB]
   ```
9. Создал общую volume-group на этих двух PV:
   ```shell
   vagrant@vagrant:~$ sudo vgcreate VG1 /dev/md0 /dev/md1
   Volume group "VG1" successfully created
   ```
   Запустим команду `vgscan`:
   ```shell
   vagrant@vagrant:~$ sudo vgscan
   Found volume group "ubuntu-vg" using metadata type lvm2
   Found volume group "VG1" using metadata type lvm2
   ```
10. Создал LV размером 100 Мб, указав его расположение на PV с RAID0:
   ```shell
   vagrant@vagrant:~$ sudo lvcreate -L 100M -n LV1 VG1 /dev/md1
   Logical volume "LV1" created.
   ```
11. Создал mkfs.ext4 ФС на получившемся LV:
   ```shell
   vagrant@vagrant:~$ sudo mkfs.ext4 /dev/VG1/LV1
   mke2fs 1.45.5 (07-Jan-2020)
   Creating filesystem with 25600 4k blocks and 25600 inodes
   
   Allocating group tables: done
   Writing inode tables: done
   Creating journal (1024 blocks): done
   Writing superblocks and filesystem accounting information: done
   ```
12. Смонтировал этот раздел в директорию `/tmp/new`:
   ```shell
   vagrant@vagrant:~$ mkdir /tmp/new
   vagrant@vagrant:~$ sudo mount /dev/VG1/LV1 /tmp/new
   ```
13. Поместил в вышеуказанный каталог тестовый файл:
   ```shell
   vagrant@vagrant:~$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
   --2022-08-22 10:42:29--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
   Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
   Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
   HTTP request sent, awaiting response... 200 OK
   Length: 22280581 (21M) [application/octet-stream]
   Saving to: ‘/tmp/new/test.gz’
   
   /tmp/new/test.gz         100%[=================================>]  21.25M  1.17MB/s    in 14s
   
   2022-08-22 10:42:44 (1.50 MB/s) - ‘/tmp/new/test.gz’ saved [22280581/22280581]
   ```
14. Вывод команды `lsblk`:
   ```shell
   vagrant@vagrant:~$ lsblk
   NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
   loop0                       7:0    0 43.6M  1 loop  /snap/snapd/14978
   loop1                       7:1    0 61.9M  1 loop  /snap/core20/1328
   loop2                       7:2    0 67.2M  1 loop  /snap/lxd/21835
   loop3                       7:3    0   62M  1 loop  /snap/core20/1611
   loop4                       7:4    0   47M  1 loop  /snap/snapd/16292
   loop5                       7:5    0 67.8M  1 loop  /snap/lxd/22753
   sda                         8:0    0   64G  0 disk
   ├─sda1                      8:1    0    1M  0 part
   ├─sda2                      8:2    0  1.5G  0 part  /boot
   └─sda3                      8:3    0 62.5G  0 part
     └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
   sdb                         8:16   0  2.5G  0 disk
   ├─sdb1                      8:17   0    2G  0 part
   │ └─md0                     9:0    0    2G  0 raid1
   └─sdb2                      8:18   0  511M  0 part
     └─md1                     9:1    0 1018M  0 raid0
       └─VG1-LV1             253:1    0  100M  0 lvm   /tmp/new
   sdc                         8:32   0  2.5G  0 disk
   ├─sdc1                      8:33   0    2G  0 part
   │ └─md0                     9:0    0    2G  0 raid1
   └─sdc2                      8:34   0  511M  0 part
     └─md1                     9:1    0 1018M  0 raid0
       └─VG1-LV1             253:1    0  100M  0 lvm   /tmp/new
   ```
15. Протестировал целостность файла:
   ```shell
   vagrant@vagrant:~$ gzip -t /tmp/new/test.gz
   vagrant@vagrant:~$ echo $?
   0
   ```
16. С помощью `pvmove` перемещаю содержимое PV с RAID0 на RAID1:
   ```shell
   vagrant@vagrant:~$ sudo pvmove /dev/md1 /dev/md0
     /dev/md1: Moved: 12.00%
     /dev/md1: Moved: 100.00%
   vagrant@vagrant:~$ lsblk
   NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
   loop0                       7:0    0 43.6M  1 loop  /snap/snapd/14978
   loop1                       7:1    0 61.9M  1 loop  /snap/core20/1328
   loop2                       7:2    0 67.2M  1 loop  /snap/lxd/21835
   loop3                       7:3    0   62M  1 loop  /snap/core20/1611
   loop4                       7:4    0   47M  1 loop  /snap/snapd/16292
   loop5                       7:5    0 67.8M  1 loop  /snap/lxd/22753
   sda                         8:0    0   64G  0 disk
   ├─sda1                      8:1    0    1M  0 part
   ├─sda2                      8:2    0  1.5G  0 part  /boot
   └─sda3                      8:3    0 62.5G  0 part
     └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
   sdb                         8:16   0  2.5G  0 disk
   ├─sdb1                      8:17   0    2G  0 part
   │ └─md0                     9:0    0    2G  0 raid1
   │   └─VG1-LV1             253:1    0  100M  0 lvm   /tmp/new
   └─sdb2                      8:18   0  511M  0 part
     └─md1                     9:1    0 1018M  0 raid0
   sdc                         8:32   0  2.5G  0 disk
   ├─sdc1                      8:33   0    2G  0 part
   │ └─md0                     9:0    0    2G  0 raid1
   │   └─VG1-LV1             253:1    0  100M  0 lvm   /tmp/new
   └─sdc2                      8:34   0  511M  0 part
     └─md1                     9:1    0 1018M  0 raid0
   ```
17. Сделал `--fail` на устройство RAID1 `md0`:
   ```shell
   vagrant@vagrant:~$ sudo mdadm /dev/md0 --fail /dev/sdc1
   mdadm: set /dev/sdc1 faulty in /dev/md0
   ```
18. Подтверждаем выводом `dmesg`, что RAID1 работает в деградированном состоянии:
   ```shell
   vagrant@vagrant:~$ dmesg | grep md0
   [ 3034.274593] md/raid1:md0: not clean -- starting background reconstruction
   [ 3034.274595] md/raid1:md0: active with 2 out of 2 mirrors
   [ 3034.274613] md0: detected capacity change from 0 to 2144337920
   [ 3034.278106] md: resync of RAID array md0
   [ 3044.868318] md: md0: resync done.
   [13772.162753] md/raid1:md0: Disk failure on sdc1, disabling device.
                  md/raid1:md0: Operation continuing on 1 devices.
   ```
19. Снова протестировал целостность файла, файл по прежнему доступен:
   ```shell
   vagrant@vagrant:~$ gzip -t /tmp/new/test.gz
   vagrant@vagrant:~$ echo $?
   0
   ```
20. Тестовый хост выключил. Команду `vagrant destroy` выполнять не стал, оставлю хост еще для экспериментов, т.к. ресурсы ПК позволяют.