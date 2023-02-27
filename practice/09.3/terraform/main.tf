terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.zone_id
}

resource "yandex_compute_image" "centos-img" {
  name         = "centos-7"
  source_image = "fd8jvcoeij6u9se84dt5"
}

resource "yandex_vpc_network" "net" {
  name = "netology"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnetology"
  zone           = var.zone_id
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["192.168.1.0/24"]
}

locals {
  instance = {
    default = 2
  }
}

resource "yandex_compute_instance" "netology-count" {
  name     = "netology-${count.index + 1}"

  resources {
    cores  = "2"
    memory = "4"
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.centos-img.id
      type     = "network-hdd"
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
    ipv6      = false
  }

  count = local.instance[terraform.workspace]

  metadata = {
    user-data = file("meta.txt")
  }
}
