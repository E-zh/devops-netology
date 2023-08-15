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
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = "ru-central1-a"
}

locals {
  network_name     = "netology-vpc"
  subnet_name1     = "public"
  subnet_name2     = "private"
  sg_nat_name      = "nat-instance-sg"
  vm_public_name   = "ubu-public"
  vm_private_name  = "ubu-private"
  vm_nat_name      = "nat-vm"
  route_table_name = "nat-instance-route"
}

resource "yandex_vpc_network" "net-vpc" {
  name = local.network_name
}

# Подсети
resource "yandex_vpc_subnet" "public-subnet" {
  name           = local.subnet_name1
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net-vpc.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "private-subnet" {
  name           = local.subnet_name2
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net-vpc.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.nat-instance-route.id
}

# правила маршрутизации
resource "yandex_vpc_security_group" "nat-instance-sg" {
  name       = local.sg_nat_name
  network_id = yandex_vpc_network.net-vpc.id

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "ssh"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-https"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }
}

# Образы ВМ
resource "yandex_compute_image" "test-vm" {
  name         = "ubuntu-2004-lts"
  source_image = "fd808e721rc1vt7jkd0o"
}

resource "yandex_compute_image" "nat-vm" {
  name         = "nat-instance-ubuntu"
  source_image = "fd80mrhj8fl2oe87o4e1"
}

# Тестовая виртуалка public
resource "yandex_compute_instance" "vm-public" {
  name        = local.vm_public_name
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.test-vm.id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public-subnet.id
  }

  metadata = {
    user-data = file("meta.txt")
  }
}

# Тестовая виртуалка private
resource "yandex_compute_instance" "vm-private" {
  name        = local.vm_private_name
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.test-vm.id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private-subnet.id
    security_group_ids = [yandex_vpc_security_group.nat-instance-sg.id]
  }

  metadata = {
    user-data = file("meta.txt")
  }
}

# NAT вм
resource "yandex_compute_instance" "nat-vm" {
  name        = local.vm_nat_name
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.nat-vm.id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public-subnet.id
    security_group_ids = [yandex_vpc_security_group.nat-instance-sg.id]
    nat                = true
  }

  metadata = {
    user-data = file("meta.txt")
  }
}

# Маршруты
resource "yandex_vpc_route_table" "nat-instance-route" {
  name       = "nat-instance-route"
  network_id = yandex_vpc_network.net-vpc.id
  static_route {
    destination_prefix = "192.168.10.254"
    next_hop_address   = yandex_compute_instance.nat-vm.network_interface.0.ip_address
  }
}
