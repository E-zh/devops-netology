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
6. Соберал RAID1 на паре разделов 2 Гб с помощью `mdadm`:
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
7. Соберал RAID0 на паре маленьких разделов с помощью `mdadm`:
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