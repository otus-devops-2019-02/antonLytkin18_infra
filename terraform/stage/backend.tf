terraform {
  backend "gcs" {
    bucket = "storage-bucket-first"
    prefix = "terraform/state"
  }
}
