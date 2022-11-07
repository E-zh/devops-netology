#cloud-config

locale: ru_RU.UTF-8

timezone: Asia/Sakhalin

users:
  - name: ${username}
    groups: sudo
    lock-passwd: false
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - ${ssh_public}