terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider yandex {
  token     = var.yc_token
  #service_account_key_file = file("key.json")
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = "ru-central1-a"
}

resource yandex_compute_image ubu-img {
  name         = "ubuntu-2204-lts"
  source_image = "fd8smb7fj0o91i68s15v"
}

resource "yandex_vpc_network" "net" {
  name = "netology"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnetology"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["192.168.1.0/24"]
}

locals {
  instance = {
    default = 1
    stage = 1
    prod  = 2
  }
}

resource "yandex_compute_instance" "netology-count" {
  name = "netology-${count.index}-${terraform.workspace}"

  resources {
    cores  = "2"
    memory = "4"
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubu-img.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  count = local.instance[terraform.workspace]

  metadata = {
    user-data = file("meta.txt")
  }
}

locals {
  id = toset([
    "1",
    "2",
  ])
}

resource "yandex_compute_instance" "netology-for" {
  for_each = local.id
  name     = "netology-${each.key}-${terraform.workspace}"

  resources {
    cores  = "2"
    memory = "4"
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubu-img.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    user-data = file("meta.txt")
  }
}