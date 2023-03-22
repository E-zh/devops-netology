#!/usr/bin/env python3

from datetime import datetime
import json
import re

cur_datetime = datetime.now()
cur_date = cur_datetime.strftime("%Y-%m-%d")
cur_timestamp = cur_datetime.strftime("%s")
metcirs_log = f"/var/log/{cur_date}-awesome-monitoring.log"


def cpu_info():

    cpu_info = {
        "cpu_percent_load": 0,
        "load_average_minute": 0,
        "running_processes": 0,
        "total_processes": 0
    }

    # CPU
    # /proc/cpuinfo
    with open('/proc/cpuinfo', 'r') as f:
        number_of_cpus = float(0)
        for string in f:
            counter = re.match(r'^processor[\s]*\:[\s]*\d', string)
            if counter:
                number_of_cpus += 1

    # Load Average
    # /proc/loadavg
    with open('/proc/loadavg', 'r') as f:
        for string in f:
            la_1m, la_5m, la_15m, proc_info, newest_pid = string.split(' ')
            running_processes, total_processes = proc_info.split('/')

    cpu_info['running_processes'] = int(running_processes)
    cpu_info['total_processes'] = int(total_processes)
    cpu_info['load_average_minute'] = float(la_1m)
    cpu_info['cpu_percent_load'] = \
        int(float(cpu_info['load_average_minute'])/number_of_cpus*100)

    return cpu_info


def mem_info():
    mem_info = {
        "mem_total_kb": 0,
        "mem_free_kb": 0,
        "mem_available_kb":0,
        "swap_total_kb": 0,
        "swap_free_kb": 0
    }
    # cat /proc/meminfo
    with open('/proc/meminfo', 'r') as f:
        for string in f:
            mem_regexp = re.match(r'^([\w\(\)\_]*):\s*(\d*)\skB', string)
            if mem_regexp and mem_regexp.group(1) == 'MemTotal':
                mem_info['mem_total_kb'] = int(mem_regexp.group(2))
            elif mem_regexp and mem_regexp.group(1) == 'MemFree':
                mem_info['mem_free_kb'] = int(mem_regexp.group(2))
            elif mem_regexp and mem_regexp.group(1) == 'MemAvailable':
                mem_info['mem_available_kb'] = int(mem_regexp.group(2))
            elif mem_regexp and mem_regexp.group(1) == 'SwapTotal':
                mem_info['swap_total_kb'] = int(mem_regexp.group(2))
            elif mem_regexp and mem_regexp.group(1) == 'SwapFree':
                mem_info['swap_free_kb'] = int(mem_regexp.group(2))
    return mem_info



def uptime_info():
    # "/proc/uptime"
    with open('/proc/uptime', 'r') as f:
        uptime_seconds = int(float(f.read().split()[0]))
    return uptime_seconds


def main():

    # Write timestamp
    export_data = {"timestamp": cur_timestamp}
    # System
    export_data = {
        **export_data,
        **cpu_info(),
        **mem_info(),
        "uptime_seconds": uptime_info()
    }

    # Write to file
    with open(metcirs_log, 'a') as f:
        f.write(json.dumps(export_data))
        f.write('\n')


if __name__ == "__main__":
    main()
