provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "storage-bucket" {
  source  = "SweetOps/storage-bucket/google"
  version = "0.1.1"

  name = ["storage-bucket-first", "storage-bucket-second"]
}

output storage-bucket_url {
  value = "${module.storage-bucket.url}"
}
