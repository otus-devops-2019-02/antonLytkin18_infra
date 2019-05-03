variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west-1"
}

variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
  default     = "~/.ssh/id_rsa"
}

variable disk_image {
  description = "Disk image"
}

variable zone {
  default = "europe-west1-b"
}

variable count {
  description = "Instances count"
  default     = 1
}
