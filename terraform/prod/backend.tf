terraform {
  backend "gcs" {
    bucket = "storage-bucket-second"
    prefix = "terraform/state"
  }
}
