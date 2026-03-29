variable "tenancy_ocid" {
  description = "OCI tenancy OCID. Also used for listing availability domains."
  type        = string
}

variable "compartment_id" {
  description = "Compartment OCID where network and compute resources are created."
  type        = string
}

variable "user_ocid" {
  description = "OCI user OCID used by the provider."
  type        = string
}

variable "fingerprint" {
  description = "Fingerprint of the OCI API signing key."
  type        = string
}

variable "private_key_pem" {
  description = "PEM-encoded OCI API private key content. Prefer this in CI."
  type        = string
  sensitive   = true
  default     = null
}

variable "private_key_path" {
  description = "Local filesystem path to the OCI API private key. Useful for workstation execution."
  type        = string
  default     = null
}

variable "private_key_password" {
  description = "Optional passphrase for the OCI API private key."
  type        = string
  sensitive   = true
  default     = null
}

variable "region" {
  description = "OCI region identifier."
  type        = string
  default     = "eu-frankfurt-1"
}

variable "availability_domain_index" {
  description = "Zero-based availability domain index in the selected region."
  type        = number
  default     = 0
}

variable "name_prefix" {
  description = "Prefix applied to created OCI resources."
  type        = string
  default     = "spring-boot-demo"
}

variable "shape" {
  description = "OCI compute shape for the k3s node."
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "shape_ocpus" {
  description = "OCPU count when using a Flex shape."
  type        = number
  default     = 4
}

variable "shape_memory_in_gbs" {
  description = "Memory size in GB when using a Flex shape."
  type        = number
  default     = 24
}

variable "boot_volume_size_in_gbs" {
  description = "Boot volume size for the node."
  type        = number
  default     = 50
}

variable "vcn_cidr" {
  description = "CIDR block for the dedicated VCN."
  type        = string
  default     = "10.42.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet that hosts the node."
  type        = string
  default     = "10.42.0.0/24"
}

variable "ssh_public_key" {
  description = "SSH public key installed for the default ubuntu user."
  type        = string
}

variable "ssh_allowed_cidrs" {
  description = "CIDR ranges allowed to reach SSH on the node."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "kubernetes_api_allowed_cidrs" {
  description = "CIDR ranges allowed to reach the Kubernetes API port."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "http_allowed_cidrs" {
  description = "CIDR ranges allowed to reach HTTP and HTTPS services."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "k3s_channel" {
  description = "K3s release channel passed to the install script."
  type        = string
  default     = "stable"
}

variable "k3s_token" {
  description = "Cluster token for k3s. If omitted, a token is generated."
  type        = string
  sensitive   = true
  default     = null
}

variable "k3s_server_extra_args" {
  description = "Additional arguments appended to the k3s server command."
  type        = list(string)
  default     = []
}

variable "freeform_tags" {
  description = "Optional OCI freeform tags applied to created resources."
  type        = map(string)
  default     = {}
}
