terraform {
  required_providers {
    incus = {
      source  = "lxc/incus"
      version = "1.0.2"
    }
  }
}

provider "incus" {
  generate_client_certificates = true
  accept_remote_certificate    = true
  default_remote               = "remote-server"

  remote {
    name    = "remote-server"
    address = "https://192.168.10.15:8443"
    token   = var.incus_token
  }
}
