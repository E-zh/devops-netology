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
}

# Resources for create the cluster
resource "yandex_vpc_network" "netology-network" {
  name = "netology-network"
}

resource "yandex_vpc_subnet" "private-1" {
  name           = "private-1"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.netology-network.id
}

resource "yandex_vpc_subnet" "private-2" {
  name           = "private-2"
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.netology-network.id
}

resource "yandex_vpc_subnet" "private-3" {
  name           = "private-3"
  v4_cidr_blocks = ["192.168.30.0/24"]
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.netology-network.id
}

resource "yandex_vpc_security_group" "cluster-sg-1" {
  name        = "cluster-sg-1"
  description = "Security group for access to the cluster"
  network_id  = yandex_vpc_network.netology-network.id

  ingress {
    protocol       = "TCP"
    description    = "Cluster input traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 3306
  }
}

# MySQL Cluster
resource "yandex_mdb_mysql_cluster" "vp-mysql-01" {
  description        = "MySQL Cluster"
  name               = "vp-mysql-01"
  environment        = "PRESTABLE"
  network_id         = yandex_vpc_network.netology-network.id
  version            = "8.0"
  security_group_ids = [yandex_vpc_security_group.cluster-sg-1.id]

  #  Enable cluster protection from inadvertent deletion
  deletion_protection = true

  #  Используем окружение Prestable, платформу Intel Broadwell с производительностью 50% CPU и размером диска 20 Гб.
  resources {
    resource_preset_id = "b1.medium"
    disk_type_id       = "network-ssd"
    disk_size          = "20"
  }

  # It is necessary to provide for replication with an arbitrary maintenance time.
  maintenance_window {
    type = "ANYTIME"
  }

  #  Set backup start time - 23:59.
  backup_window_start {
    hours   = "23"
    minutes = "59"
  }

  host {
    name      = "node-1"
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.private-1.id
  }
  host {
    name      = "node-2"
    zone      = "ru-central1-b"
    subnet_id = yandex_vpc_subnet.private-2.id
  }
  host {
    name      = "node-3"
    zone      = "ru-central1-c"
    subnet_id = yandex_vpc_subnet.private-3.id
  }

  depends_on = [
    yandex_vpc_network.netology-network,
    yandex_vpc_subnet.private-1,
    yandex_vpc_subnet.private-2,
    yandex_vpc_subnet.private-3,
    yandex_vpc_security_group.cluster-sg-1
  ]
}

# Create database in to cluster
resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.vp-mysql-01.id
  name       = var.database_name
}
# Create database user in to cluster
resource "yandex_mdb_mysql_user" "database_user" {
  cluster_id = yandex_mdb_mysql_cluster.vp-mysql-01.id
  name       = var.database_user
  password   = var.database_password
  permission {
    database_name = yandex_mdb_mysql_database.netology_db.name
    roles         = ["ALL"]
  }
}

# Output data
output "connection_current_master" {
  description = "Master address in the database cluster"
  value       = "c-${yandex_mdb_mysql_cluster.vp-mysql-01.id}.rw.mdb.yandexcloud.net"
}
output "connection_nodes" {
  description = "Addresses of created nodes in the database cluster"
  value       = yandex_mdb_mysql_cluster.vp-mysql-01.host.*.fqdn
}

# We write the address of the master in the cluster to the variable file Helm chart for PHPMyAdmin
resource "local_file" "output_master_address" {
  content = <<-DOC
    database:
      serverUrl: "c-${yandex_mdb_mysql_cluster.vp-mysql-01.id}.rw.mdb.yandexcloud.net"
    DOC

  filename   = "k8s/helm/pma/values.yaml"
  depends_on = [
    yandex_mdb_mysql_cluster.vp-mysql-01
  ]
}
