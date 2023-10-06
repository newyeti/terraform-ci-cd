resource "google_cloud_run_v2_service" "datasync-service" {
  project = var.project
  name     = "datasync-service"
  location = var.region
  

  template {

    scaling {
      max_instance_count = 1
      min_instance_count = 0
    }

    containers {
      name = "datasync-service"
      image = "us-central1-docker.pkg.dev/newyeti/images/newyeti-datasync-service:${var.datasync_image_tag}"

      resources {
        limits = {
          memory = "1024Mi"
        }
      } 
      ports {
        container_port = 80
      }
    }
  }
  traffic {
    type = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}

resource "google_cloud_run_v2_service_iam_policy" "datasync-service-policy" {
  project = google_cloud_run_v2_service.datasync-service.project
  location = google_cloud_run_v2_service.datasync-service.location
  name = google_cloud_run_v2_service.datasync-service.name
  policy_data = data.google_iam_policy.public-1.policy_data
}
