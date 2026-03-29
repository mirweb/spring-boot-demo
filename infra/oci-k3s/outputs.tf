output "availability_domain" {
  description = "Availability domain used for the node."
  value       = oci_core_instance.node.availability_domain
}

output "instance_id" {
  description = "OCI instance OCID for the k3s node."
  value       = oci_core_instance.node.id
}

output "public_ip" {
  description = "Public IP assigned to the k3s node."
  value       = data.oci_core_vnic.node.public_ip_address
}

output "private_ip" {
  description = "Private IP assigned to the k3s node."
  value       = data.oci_core_vnic.node.private_ip_address
}

output "ssh_command" {
  description = "SSH command for the default Ubuntu user."
  value       = "ssh ubuntu@${data.oci_core_vnic.node.public_ip_address}"
}

output "kubeconfig_fetch_command" {
  description = "Command to copy the generated kubeconfig locally."
  value       = "scp ubuntu@${data.oci_core_vnic.node.public_ip_address}:/etc/rancher/k3s/k3s.yaml ./k3s.yaml"
}

output "gitlab_state_name" {
  description = "Default GitLab-managed OpenTofu state name used by the helper script."
  value       = "oci-k3s"
}
