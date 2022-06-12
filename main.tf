terraform {
required_providers {
yandex = {
source = "yandex-cloud/yandex"
version = "0.75.0"
}
}
}

provider "yandex" {
token = "AQAAAABde8_HAATuwaSJs9Xrl0-ogoRQMTHrGn0"
cloud_id = "b1gl0ubjulr2bvmjjps3"
folder_id = var.folder_id
zone = "ru-central1-a"
}

resource "yandex_iam_service_account" "sa" {
folder_id = var.folder_id
name = "sa-skillfactory"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
folder_id = var.folder_id
role = "storage.editor"
member = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
service_account_id = yandex_iam_service_account.sa.id
description = "blank"
}

resource "yandex_storage_bucket" "state" {
access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
bucket = "tf-state-bucket-mentor"
}