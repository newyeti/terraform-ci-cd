provider "kubernetes" {
  config_path = "~/.kube/footy-k8s-config"
}

provider "oci" {
  region = var.region
}

resource "kubernetes_namespace" "footy_namespace" {
  metadata {
    name = "footy"
  }
}

data "oci_containerengine_node_pool" "footy_k8s_np" {
  node_pool_id = var.node_pool_id
}

locals {
  active_nodes = [for node in data.oci_containerengine_node_pool.footy_k8s_np.nodes : node if node.state == "ACTIVE"]
}

# Nginx - Network Load Balancer
resource "oci_network_load_balancer_network_load_balancer" "footy_nlb" {
  compartment_id = var.compartment_id
  display_name   = "footy-k8s-nlb"
  subnet_id      = var.public_subnet_id

  is_private                     = false
  is_preserve_source_destination = false
}

resource "oci_network_load_balancer_backend_set" "footy_nlb_backend_set" {
  health_checker {
    protocol = "TCP"
    port     = 10256
  }
  name                     = "footy-k8s-backend-set"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.footy_nlb.id
  policy                   = "FIVE_TUPLE"

  is_preserve_source = false
}

resource "oci_network_load_balancer_backend" "footy_nlb_backend" {
  count                    = length(local.active_nodes)
  backend_set_name         = oci_network_load_balancer_backend_set.footy_nlb_backend_set.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.footy_nlb.id
  port                     = 31600
  target_id                = local.active_nodes[count.index].id
}

resource "oci_network_load_balancer_listener" "footy_nlb_listener" {
  default_backend_set_name = oci_network_load_balancer_backend_set.footy_nlb_backend_set.name
  name                     = "footy-k8s-nlb-listener"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.footy_nlb.id
  port                     = "443"
  protocol                 = "TCP"
}

# Grafana - Network Load Balancer
resource "oci_network_load_balancer_network_load_balancer" "footy_grafana_nlb" {
  compartment_id = var.compartment_id
  display_name   = "footy-grafana-k8s-nlb"
  subnet_id      = var.public_subnet_id

  is_private                     = false
  is_preserve_source_destination = false
}

resource "oci_network_load_balancer_backend_set" "footy_grafana_nlb_backend_set" {
  health_checker {
    protocol = "TCP"
    port     = 10256
  }
  name                     = "footy-grafana-k8s-backend-set"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.footy_grafana_nlb.id
  policy                   = "FIVE_TUPLE"

  is_preserve_source = false
}

resource "oci_network_load_balancer_backend" "footy_grafana_nlb_backend" {
  count                    = length(local.active_nodes)
  backend_set_name         = oci_network_load_balancer_backend_set.footy_grafana_nlb_backend_set.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.footy_grafana_nlb.id
  port                     = 31610
  target_id                = local.active_nodes[count.index].id
}

resource "oci_network_load_balancer_listener" "footy_grafana_nlb_listener" {
  default_backend_set_name = oci_network_load_balancer_backend_set.footy_grafana_nlb_backend_set.name
  name                     = "footy-grafana-k8s-nlb-listener"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.footy_grafana_nlb.id
  port                     = "3000"
  protocol                 = "TCP"
}