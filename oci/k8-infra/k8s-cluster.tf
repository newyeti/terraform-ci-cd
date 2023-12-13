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

resource "kubernetes_deployment" "nginx_deployment" {
  metadata {
    name = "nginx"
    labels = {
      app = "nginx"
    }
    namespace = kubernetes_namespace.footy_namespace.id
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "nginx"
          name  = "nginx"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "grafana_deployment" {
  metadata {
    name = "grafana"
    labels = {
      app = "grafana"
    }
    namespace = kubernetes_namespace.footy_namespace.id
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "grafana"
      }
    }

    template {
      metadata {
        labels = {
          app = "grafana"
        }
      }

      spec {
        container {
          image = "grafana/grafana:latest"
          name  = "grafana"
          port {
            container_port = 3000
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "nginx_service" {
  metadata {
    name      = "nginx-service"
    namespace = kubernetes_namespace.footy_namespace.id
  }
  spec {
    selector = {
      app = "nginx"
    }

    type = "LoadBalancer"

    port {
      name = "nginx"
      port        = 80
      target_port = 80
      # node_port   = 31600
    }
    # port {
    #   name = "grafana"
    #   port        = 3000
    #   target_port = 3000
    #   # node_port   = 31600
    # }
  }
}

# data "oci_containerengine_node_pool" "footy_k8s_np" {
#   node_pool_id = var.node_pool_id
# }

# locals {
#   active_nodes = [for node in data.oci_containerengine_node_pool.footy_k8s_np.nodes : node if node.state == "ACTIVE"]
# }

# resource "oci_network_load_balancer_network_load_balancer" "footy_nlb" {
#   compartment_id = var.compartment_id
#   display_name   = "footy-k8s-nlb"
#   subnet_id      = var.public_subnet_id

#   is_private                     = false
#   is_preserve_source_destination = false
# }

# resource "oci_network_load_balancer_backend_set" "footy_nlb_backend_set" {
#   health_checker {
#     protocol = "TCP"
#     port     = 10256
#   }
#   name                     = "footy-k8s-backend-set"
#   network_load_balancer_id = oci_network_load_balancer_network_load_balancer.footy_nlb.id
#   policy                   = "FIVE_TUPLE"

#   is_preserve_source = false
# }

# resource "oci_network_load_balancer_backend" "footy_nlb_backend" {
#   count                    = length(local.active_nodes)
#   backend_set_name         = oci_network_load_balancer_backend_set.footy_nlb_backend_set.name
#   network_load_balancer_id = oci_network_load_balancer_network_load_balancer.footy_nlb.id
#   port                     = 31600
#   target_id                = local.active_nodes[count.index].id
# }

# resource "oci_network_load_balancer_listener" "footy_nlb_listener" {
#   default_backend_set_name = oci_network_load_balancer_backend_set.footy_nlb_backend_set.name
#   name                     = "footy-k8s-nlb-listener"
#   network_load_balancer_id = oci_network_load_balancer_network_load_balancer.footy_nlb.id
#   port                     = "80"
#   protocol                 = "TCP"
# }

