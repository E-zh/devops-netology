# devops-netology

## HomeWork 3.4
### Желобанов Егор DEVOPS-21

1. Скачал и установил `node_exporter`:
   - `sudo -i`, сразу переключился на root;
   - `cd /opt`, перешел в каталог `opt`;
   - `wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz`, скачал архив с сайта `prometheus.io`;
   - `tar xzf node_exporter-1.3.1.linux-amd64.tar.gz`, распаковал архив
   - `touch node_exporter-1.3.1.linux-amd64/node_exporter_env`, создаем файл для добавления опций, и добавил в него строку `EXTRA_OPTS="--log.level=info"`
   - `touch /etc/systemd/system/node_exporter.service`, создал unit-файл сервиса, добавил в него следующее содержимое:
   ```shell
    [Unit]
    Description=node_exporter
    
    [Service]
    EnvironmentFile=/opt/node_exporter-1.3.1.linux-amd64/node_exporter_env
    ExecStart=/opt/node_exporter-1.3.1.linux-amd64/node_exporter $EXTRA_OPTS
    
    [Install]
    WantedBy=default.target
   ```
   - добавляем сервис в автозагрузку - `systemctl enable node_exporter`;
   - запускаем сервис - `systemctl start node_exporter`
   - проверяем статус - `systemctl status node_exporter`, видим такое сообщение, сервис работает:
   ```shell
     node_exporter.service - node_exporter
         Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
         Active: active (running) since Wed 2022-08-17 23:48:09 +11; 3s ago
       Main PID: 2635 (node_exporter)
          Tasks: 5 (limit: 1066)
         Memory: 2.4M
         CGroup: /system.slice/node_exporter.service
                 └─2635 /opt/node_exporter-1.3.1.linux-amd64/node_exporter --log.level=info
    
    Aug 17 23:48:09 vagrant node_exporter[2635]: ts=2022-08-17T12:48:09.214Z caller=node_exporter.go:115 level=info collector=thermal_zone
    Aug 17 23:48:09 vagrant node_exporter[2635]: ts=2022-08-17T12:48:09.214Z caller=node_exporter.go:115 level=info collector=time
    Aug 17 23:48:09 vagrant node_exporter[2635]: ts=2022-08-17T12:48:09.214Z caller=node_exporter.go:115 level=info collector=timex
    Aug 17 23:48:09 vagrant node_exporter[2635]: ts=2022-08-17T12:48:09.214Z caller=node_exporter.go:115 level=info collector=udp_queues
    Aug 17 23:48:09 vagrant node_exporter[2635]: ts=2022-08-17T12:48:09.214Z caller=node_exporter.go:115 level=info collector=uname
    Aug 17 23:48:09 vagrant node_exporter[2635]: ts=2022-08-17T12:48:09.214Z caller=node_exporter.go:115 level=info collector=vmstat
    Aug 17 23:48:09 vagrant node_exporter[2635]: ts=2022-08-17T12:48:09.214Z caller=node_exporter.go:115 level=info collector=xfs
    Aug 17 23:48:09 vagrant node_exporter[2635]: ts=2022-08-17T12:48:09.214Z caller=node_exporter.go:115 level=info collector=zfs
    Aug 17 23:48:09 vagrant node_exporter[2635]: ts=2022-08-17T12:48:09.214Z caller=node_exporter.go:199 level=info msg="Listening on" address=:9100
    Aug 17 23:48:09 vagrant node_exporter[2635]: ts=2022-08-17T12:48:09.214Z caller=tls_config.go:195 level=info msg="TLS is disabled." http2=false
    ```
   - в VirtualBox пробросил порт 9100, зашел по адресу `http://localhost:9100/metrics`, вижу следующее:
   ```shell
    # HELP go_gc_duration_seconds A summary of the pause duration of garbage collection cycles.
    # TYPE go_gc_duration_seconds summary
    go_gc_duration_seconds{quantile="0"} 0
    go_gc_duration_seconds{quantile="0.25"} 0
    go_gc_duration_seconds{quantile="0.5"} 0
    go_gc_duration_seconds{quantile="0.75"} 0
    go_gc_duration_seconds{quantile="1"} 0
    go_gc_duration_seconds_sum 0
    go_gc_duration_seconds_count 0
    # HELP go_goroutines Number of goroutines that currently exist.
    # TYPE go_goroutines gauge
    go_goroutines 8
    # HELP node_cpu_seconds_total Seconds the CPUs spent in each mode.
    # TYPE node_cpu_seconds_total counter
    node_cpu_seconds_total{cpu="0",mode="idle"} 8638.77
    node_cpu_seconds_total{cpu="0",mode="iowait"} 14.78
    node_cpu_seconds_total{cpu="0",mode="irq"} 0
    node_cpu_seconds_total{cpu="0",mode="nice"} 0.02
    node_cpu_seconds_total{cpu="0",mode="softirq"} 2.39
    node_cpu_seconds_total{cpu="0",mode="steal"} 0
    node_cpu_seconds_total{cpu="0",mode="system"} 12.68
    node_cpu_seconds_total{cpu="0",mode="user"} 9.83
    node_cpu_seconds_total{cpu="1",mode="idle"} 8038.05
    node_cpu_seconds_total{cpu="1",mode="iowait"} 13.23
    node_cpu_seconds_total{cpu="1",mode="irq"} 0
    node_cpu_seconds_total{cpu="1",mode="nice"} 0
    node_cpu_seconds_total{cpu="1",mode="softirq"} 2.02
    node_cpu_seconds_total{cpu="1",mode="steal"} 0
    node_cpu_seconds_total{cpu="1",mode="system"} 12.3
    node_cpu_seconds_total{cpu="1",mode="user"} 2.36
    ```
   Командами процесс корректно запускается, останавливается, перезапускается. После перезагрузки автоматически запускается.
2. Ознакомился с опциями node_exporter, опции для базового мониторинга хоста:
   - по CPU:
   ```shell
    node_cpu_seconds_total{cpu="0",mode="idle"} 9014.82
    node_cpu_seconds_total{cpu="0",mode="iowait"} 14.8
    node_cpu_seconds_total{cpu="0",mode="irq"} 0
    node_cpu_seconds_total{cpu="0",mode="nice"} 0.04
    node_cpu_seconds_total{cpu="0",mode="softirq"} 2.43
    node_cpu_seconds_total{cpu="0",mode="steal"} 0
    node_cpu_seconds_total{cpu="0",mode="system"} 12.91
    node_cpu_seconds_total{cpu="0",mode="user"} 9.91
    node_cpu_seconds_total{cpu="1",mode="idle"} 8413.57
    node_cpu_seconds_total{cpu="1",mode="iowait"} 13.3
    node_cpu_seconds_total{cpu="1",mode="irq"} 0
    node_cpu_seconds_total{cpu="1",mode="nice"} 0
    node_cpu_seconds_total{cpu="1",mode="softirq"} 2.06
    node_cpu_seconds_total{cpu="1",mode="steal"} 0
    node_cpu_seconds_total{cpu="1",mode="system"} 12.54
    node_cpu_seconds_total{cpu="1",mode="user"} 2.43
    ```
   - по памяти:
   ```shell
    node_memory_MemAvailable_bytes 6.90540544e+08
    node_memory_MemFree_bytes 1.74743552e+08
    node_memory_MemTotal_bytes 1.024069632e+09
    node_memory_Mlocked_bytes 2.3334912e+07
    node_memory_SwapCached_bytes 0
    node_memory_SwapFree_bytes 2.047864832e+09
    node_memory_SwapTotal_bytes 2.047864832e+09
    ```
   - по диску:
   ```shell
    node_disk_io_now{device="dm-0"} 0
    node_disk_io_now{device="sda"} 0
    node_disk_read_bytes_total{device="dm-0"} 4.18190336e+08
    node_disk_read_bytes_total{device="sda"} 4.281856e+08
    node_disk_read_time_seconds_total{device="dm-0"} 97.748
    node_disk_read_time_seconds_total{device="sda"} 54.497
    node_disk_write_time_seconds_total{device="dm-0"} 37.84
    node_disk_write_time_seconds_total{device="sda"} 34.063
    node_disk_writes_completed_total{device="dm-0"} 12292
    node_disk_writes_completed_total{device="sda"} 6352
    node_disk_written_bytes_total{device="dm-0"} 3.95169792e+08
    node_disk_written_bytes_total{device="sda"} 3.92937472e+08
    ```
   - по сети:
   ```shell
   node_network_receive_bytes_total{device="eth0"} 1.1278425e+07
   node_network_receive_errs_total{device="eth0"} 0
   node_network_transmit_bytes_total{device="eth0"} 675426
   node_network_transmit_errs_total{device="eth0"} 0
   ```
3. Установил Netdata, выполнил все по инструкции, зашел по адресу и увидел дашборд системы мониторинга, с метриками ознакомился, [загрузил скриншот экрана](https://drive.google.com/file/d/1zY3LHGny-uYSzTnkIBC7OG8dQ3_RyJww/view?usp=sharing)
4. Да, судя по выводу команды `dmesg` можно, приведу несколько строк из того что вывела данная команда:  
   ```shell
   [    0.000000] DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
   [    0.000000] Hypervisor detected: KVM
   [   10.904885] systemd[1]: Detected virtualization oracle.
   ```
5. Значение `fs.nr_open` можно получить выполнив команду `sysctl -n fs.nr_open`. Это максимальное число открытых дескрипторов для ядра системы. Значение по умолчанию - 1048576.
   Данное число задается с шагом 1024, и в данном случае равно `1024*1024`. Это значение не позволит достичь другое ограничение - `open files` из вывода команды `ulimit -a`, дефолтное значение которого равно 1024.
6. Запустил команду `sleep 1h`. Далее зашел из другой консоли:
   ```shell
   root@vagrant:~# ps -e | grep sleep
   1605 pts/0    00:00:00 sleep
   root@vagrant:/# nsenter --target 1605 --pid --mount
   root@vagrant:/# ps
    PID TTY          TIME CMD
    1 pts/0    00:00:00 sleep
    2 pts/0    00:00:00 bash
   14 pts/0    00:00:00 ps
   ```
7. ` :(){ :|:& };: `- это fork-бомба. для понятности заменим `:` именем `f` и отформатируем код:
   ```shell
   f() {
     f | f &
   };
   f
   ```
   Таким образом, это функция, которая параллельно пускает два своих экземпляра. Каждый пускает ещё по два и т.д., пока не достигнет ограничения `ulimit -u` - количество процессов на пользователя. Сообщение об этом в `dmesg`:
   ```shell
   [ 2302.209556] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-6.scope
   ```
   Если установить `ulimit -u 30` - то число процессов будет ограниченно 30 для пользователя. 