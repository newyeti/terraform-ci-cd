resource "google_cloud_run_v2_service" "config-service" {
  project = var.project
  name     = "config-service"
  location = var.region

  template {

    scaling {
      max_instance_count = 1
      min_instance_count = 0
    }

    containers {
      name = "config-service"
      image = "us-central1-docker.pkg.dev/newyeti/images/newyeti-config-server:v1.3.6"
      ports {
        container_port = 9091
      }
      env {
        name = "CONFIG_SERVER_GIT_URI"
        value = "https://github.com/newyeti/configuration.git"
      }
    }
  }
  traffic {
    type = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}

resource "google_cloud_run_v2_service_iam_policy" "config-service-policy" {
  project = google_cloud_run_v2_service.config-service.project
  location = google_cloud_run_v2_service.config-service.location
  name = google_cloud_run_v2_service.config-service.name
  policy_data = data.google_iam_policy.public-1.policy_data
}
