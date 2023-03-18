terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      # source = "terraform-registry.storage.yandexcloud.net/yandex-cloud/yandex" # Alternate link
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yc_token          # Set OAuth or IAM token
  cloud_id  = var.yc_cloud_id       # Set your cloud ID
  folder_id = var.yc_folder_id      # Set your cloud folder ID
  zone      = var.zone_id           # Availability zone by default, one of ru-central1-a, ru-central1-b, ru-central1-c
}
