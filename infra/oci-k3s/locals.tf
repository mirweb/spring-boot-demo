locals {
  cluster_name         = "${var.name_prefix}-k3s"
  selected_ad_index    = max(0, var.availability_domain_index)
  selected_domain_name = data.oci_identity_availability_domains.available.availability_domains[local.selected_ad_index].name
  uses_flex_shape      = can(regex("\\.Flex$", var.shape))
  k3s_server_args      = join(" ", var.k3s_server_extra_args)
  effective_k3s_token  = var.k3s_token != null ? var.k3s_token : random_password.k3s_token[0].result
  normalized_ssh_key   = trimspace(var.ssh_public_key)
}
