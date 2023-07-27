# resource "google_compute_instance" "my_instance" {
#   name = var.vm_params.name
#   machine_type = var.vm_params.machine_type
#   zone = var.vm_params.zone
#   allow_stopping_for_update = var.vm_params.allow_stopping_for_update

#   boot_disk {
#     initialize_params {
#       image = var.os_image
#     }
#   }

#   network_interface {
#     network = google_compute_network.terraform_network.self_link
#     subnetwork = google_compute_subnetwork.terraform_subnetwork.self_link
#     access_config {
#     }
#   }
# }

# resource "google_compute_network" "terraform_network" {
#   name = var.network_params.name
#   auto_create_subnetworks = var.network_params.auto_create_subnetworks
# }

# resource "google_compute_subnetwork" "terraform_subnetwork" {
#   name = var.subnetwork_params.name
#   ip_cidr_range = var.subnetwork_params.ip_cidr_range
#   region = var.subnetwork_params.region
#   network = google_compute_network.terraform_network.id
# }

# resource "google_project_service" "enable_cloud_run_api" {
#   project = "newyeti"
#   service = "run.googleapis.com"
#   disable_dependent_services = true
# }

# resource "google_project_service" "enable_cloudresourcemanager_api" {
#   service = "cloudresourcemanager.googleapis.com"
#   project = var.project
# }