# Resources for create the cluster
resource "yandex_vpc_subnet" "public-1" {
  name           = "public-1"
  v4_cidr_blocks = ["192.168.40.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.netology-network.id
}

resource "yandex_vpc_subnet" "public-2" {
  name           = "public-2"
  v4_cidr_blocks = ["192.168.50.0/24"]
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.netology-network.id
}

resource "yandex_vpc_subnet" "public-3" {
  name           = "public-3"
  v4_cidr_blocks = ["192.168.60.0/24"]
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.netology-network.id
}

# Create service account and assigned roles and grant rights to various functions
resource "yandex_iam_service_account" "kuber-sa-account" {
  description = "Service account for K8S cluster"
  name        = var.kuber-sa-name
}

## role "k8s.clusters.agent"
resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
  folder_id = var.yc_folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.kuber-sa-account.id}"
}

## role "vpc.publicAdmin"
resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
  folder_id = var.yc_folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.kuber-sa-account.id}"
}

## role "container-registry.images.puller"
resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
  folder_id = var.yc_folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.kuber-sa-account.id}"
}

## role "load-balancer.admin"
resource "yandex_resourcemanager_folder_iam_member" "kuber-sa-lb-admin" {
  folder_id = var.yc_folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.kuber-sa-account.id}"
}

## create key for encrypt important information (ex: OAuth-tokens, SSH-keys, passwords)
resource "yandex_kms_symmetric_key" "kms-key" {
  name              = "kms-key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год.
}

## provide access to the encryption key
resource "yandex_kms_symmetric_key_iam_binding" "viewer" {
  symmetric_key_id = yandex_kms_symmetric_key.kms-key.id
  role             = "viewer"
  members          = [
    "serviceAccount:${yandex_iam_service_account.kuber-sa-account.id}"
  ]
}

# Create the cluster and group of nodes
resource "yandex_kubernetes_cluster" "k8s-regional" {
  description        = "K8S Cluster"
  name               = "vp-k8s-cluster-01"
  network_id         = yandex_vpc_network.netology-network.id
  cluster_ipv4_range = "10.1.0.0/16"
  service_ipv4_range = "10.2.0.0/16"

  master {
    version   = var.k8s_version
    public_ip = true

    # Create a regional Kubernetes master with nodes on three different subnets.
    regional {
      region = "ru-central1"
      location {
        zone      = yandex_vpc_subnet.public-1.zone
        subnet_id = yandex_vpc_subnet.public-1.id
      }
      location {
        zone      = yandex_vpc_subnet.public-2.zone
        subnet_id = yandex_vpc_subnet.public-2.id
      }
      location {
        zone      = yandex_vpc_subnet.public-3.zone
        subnet_id = yandex_vpc_subnet.public-3.id
      }
    }
  }
  service_account_id      = yandex_iam_service_account.kuber-sa-account.id
  node_service_account_id = yandex_iam_service_account.kuber-sa-account.id

  #  Add the ability to encrypt with a key from KMS created in the previous homework.
  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key.id
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
    yandex_resourcemanager_folder_iam_member.images-puller,
    yandex_resourcemanager_folder_iam_member.kuber-sa-lb-admin,
    yandex_kms_symmetric_key.kms-key,
    yandex_kms_symmetric_key_iam_binding.viewer
  ]
}

# Create a node group consisting of three machines, autoscaling to six.
resource "yandex_kubernetes_node_group" "k8s-ng-01" {
  description = "Группа узлов для кластера"
  cluster_id  = yandex_kubernetes_cluster.k8s-regional.id
  name        = "k8s-ng-01"
  instance_template {
    platform_id = "standard-v2"
    container_runtime {
      type = "containerd"
    }
    network_interface {
      nat        = true
      subnet_ids = [yandex_vpc_subnet.public-1.id]
    }
    scheduling_policy {
      preemptible = true
    }
    metadata = {
      ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
    }
  }

  scale_policy {
    auto_scale {
      initial = 3
      max     = 6
      min     = 3
    }
  }
  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  depends_on = [
    yandex_kubernetes_cluster.k8s-regional,
    yandex_vpc_subnet.public-1
  ]

}

# Output data
output "k8s_external_v4_endpoint" {
  value       = yandex_kubernetes_cluster.k8s-regional.master[0].external_v4_endpoint
  description = "Endpoint for connecting to a cluster"
}
output "k8s_cluster_id" {
  value       = yandex_kubernetes_cluster.k8s-regional.id
  description = "ID of created cluster"
}
