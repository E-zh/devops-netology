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
  zone      = var.yc_region
}

# Service account for bucket
resource "yandex_iam_service_account" "bucket-sa" {
  name        = "bucket-sa"
  description = "сервисный аккаунт для управления s3-бакетом"
}

# Role for service account
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.yc_folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.bucket-sa.id}"
}
# Encryption/decryption of data with KMS keys
resource "yandex_resourcemanager_folder_iam_member" "sa-editor-encrypter-decrypter" {
  folder_id = var.yc_folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.bucket-sa.id}"
}

# Creating access keys for a service account
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.bucket-sa.id
  description        = "static access key for object storage"
}

# Bucket Encryption Key
resource "yandex_kms_symmetric_key" "key-1" {
  name              = "key-1"
  description       = "Bucket Encryption Key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 Year
}

# Create a bucket with the specified access keys and encryption with the selected key
resource "yandex_storage_bucket" "vp-bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "vp-netology-bucket"

  max_size = 1073741824 # 1 Gb

  anonymous_access_flags {
    read = true
    list = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-1.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

# Uploading an image to a bucket
resource "yandex_storage_object" "yc_image" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.vp-bucket.id
  key        = "image.png"
  source     = var.yc_image
}

# Result: display the received data
output "pic-url" {
  value       = "https://${yandex_storage_bucket.vp-bucket.bucket_domain_name}/${yandex_storage_object.yc_image.key}"
  description = "The address of the picture uploaded to the bucket"
}
