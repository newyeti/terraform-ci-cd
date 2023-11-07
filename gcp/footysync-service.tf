resource "google_cloud_run_v2_service" "footysync-service" {
  project = var.project
  name     = "footysync-service"
  location = var.region
  

  template {

    scaling {
      max_instance_count = 1
      min_instance_count = 0
    }

    containers {
      name = "footysync-service"
      image = "us-central1-docker.pkg.dev/newyeti/footy/footysync-service:${var.footysync_image_tag}"

      resources {
        limits = {
          memory = "1024Mi"
        }
      } 
      ports {
        container_port = 80
      }

      env{
        name = "APP_ENV"
        value = "prod"
      }

      env {
        name = "INFRA"
        value_source {
          secret_key_ref {
            version = "latest"
            secret = "footy_cred"
          }
        }
      }

      env {
        name = "infra"
        value_source {
          secret_key_ref {
            version = "latest"
            secret = "footy_cred"
          }
        }
      }
      
      env {
        name = "RAPID_API"
        value_source {
          secret_key_ref {
            version = "latest"
            secret = "rapid-api-keys"
          }
        }
      }

      env {
        name = "rapid_api"
        value_source {
          secret_key_ref {
            version = "latest"
            secret = "rapid-api-keys"
          }
        }
      }


    }
  }
  traffic {
    type = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}


resource "google_cloud_run_v2_service_iam_policy" "footysync-service-policy" {
  project = google_cloud_run_v2_service.footysync-service.project
  location = google_cloud_run_v2_service.footysync-service.location
  name = google_cloud_run_v2_service.footysync-service.name
  policy_data = data.google_iam_policy.public-1.policy_data
}
