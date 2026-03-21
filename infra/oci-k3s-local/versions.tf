terraform {
  required_version = ">= 1.8.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.24"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
