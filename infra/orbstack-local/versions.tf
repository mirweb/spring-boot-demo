terraform {
  required_version = ">= 1.11.0"

  backend "http" {
    address        = "https://gitlab.com/api/v4/projects/80076845/terraform/state/orbstack-local"
    lock_address   = "https://gitlab.com/api/v4/projects/80076845/terraform/state/orbstack-local/lock"
    unlock_address = "https://gitlab.com/api/v4/projects/80076845/terraform/state/orbstack-local/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
  }

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.36"
    }
  }
}
