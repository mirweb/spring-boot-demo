data "oci_identity_availability_domains" "available" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_images" "ubuntu" {
  compartment_id           = var.compartment_id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04"
  shape                    = var.shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
  state                    = "AVAILABLE"
}

resource "random_password" "k3s_token" {
  count   = var.k3s_token == null ? 1 : 0
  length  = 32
  special = false
}

resource "oci_core_vcn" "cluster" {
  compartment_id = var.compartment_id
  cidr_blocks    = [var.vcn_cidr]
  display_name   = "${local.cluster_name}-vcn"
  dns_label      = "k3svcn"
  freeform_tags  = var.freeform_tags
}

resource "oci_core_internet_gateway" "cluster" {
  compartment_id = var.compartment_id
  display_name   = "${local.cluster_name}-igw"
  vcn_id         = oci_core_vcn.cluster.id
  enabled        = true
  freeform_tags  = var.freeform_tags
}

resource "oci_core_route_table" "cluster" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.cluster.id
  display_name   = "${local.cluster_name}-rt"
  freeform_tags  = var.freeform_tags

  route_rules {
    network_entity_id = oci_core_internet_gateway.cluster.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_security_list" "cluster" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.cluster.id
  display_name   = "${local.cluster_name}-sl"
  freeform_tags  = var.freeform_tags

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  dynamic "ingress_security_rules" {
    for_each = var.ssh_allowed_cidrs
    content {
      protocol = "6"
      source   = ingress_security_rules.value

      tcp_options {
        min = 22
        max = 22
      }
    }
  }

  dynamic "ingress_security_rules" {
    for_each = var.kubernetes_api_allowed_cidrs
    content {
      protocol = "6"
      source   = ingress_security_rules.value

      tcp_options {
        min = 6443
        max = 6443
      }
    }
  }

  dynamic "ingress_security_rules" {
    for_each = var.http_allowed_cidrs
    content {
      protocol = "6"
      source   = ingress_security_rules.value

      tcp_options {
        min = 80
        max = 80
      }
    }
  }

  dynamic "ingress_security_rules" {
    for_each = var.http_allowed_cidrs
    content {
      protocol = "6"
      source   = ingress_security_rules.value

      tcp_options {
        min = 443
        max = 443
      }
    }
  }
}

resource "oci_core_subnet" "cluster" {
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.cluster.id
  cidr_block                 = var.subnet_cidr
  display_name               = "${local.cluster_name}-subnet"
  dns_label                  = "k3ssubnet"
  route_table_id             = oci_core_route_table.cluster.id
  security_list_ids          = [oci_core_security_list.cluster.id]
  prohibit_public_ip_on_vnic = false
  freeform_tags              = var.freeform_tags
}

resource "oci_core_instance" "node" {
  availability_domain = local.selected_domain_name
  compartment_id      = var.compartment_id
  display_name        = local.cluster_name
  shape               = var.shape
  freeform_tags       = var.freeform_tags

  dynamic "shape_config" {
    for_each = local.uses_flex_shape ? [1] : []
    content {
      ocpus         = var.shape_ocpus
      memory_in_gbs = var.shape_memory_in_gbs
    }
  }

  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.cluster.id
    display_name     = "${local.cluster_name}-primary-vnic"
    hostname_label   = "k3snode"
  }

  metadata = {
    ssh_authorized_keys = local.normalized_ssh_key
    user_data = base64encode(templatefile("${path.module}/cloud-init.yaml.tftpl", {
      hostname        = local.cluster_name
      k3s_channel     = var.k3s_channel
      k3s_server_args = local.k3s_server_args
      k3s_token       = local.effective_k3s_token
    }))
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.ubuntu.images[0].id
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
  }

  instance_options {
    are_legacy_imds_endpoints_disabled = true
  }
}

data "oci_core_vnic_attachments" "node" {
  compartment_id      = var.compartment_id
  availability_domain = oci_core_instance.node.availability_domain
  instance_id         = oci_core_instance.node.id
}

data "oci_core_vnic" "node" {
  vnic_id = data.oci_core_vnic_attachments.node.vnic_attachments[0].vnic_id
}
