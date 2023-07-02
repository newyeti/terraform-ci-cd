resource "google_cloud_run_v2_service" "producer-service" {
  project = var.project
  name     = "producer-service"
  location = var.region

  template {

    scaling {
      max_instance_count = 1
      min_instance_count = 0
    }

    containers {
      name = "producer-service"
      image = "us-central1-docker.pkg.dev/newyeti/images/newyeti-producer:v1.1.6"
      ports {
        container_port = 4000
      }
      env {
        name = "SPRING_PROFILES_ACTIVE"
        value = "gcp"
      }
      env {
        name = "CONFIG_SERVER_URI"
        value = "https://config-service-hrvpv77zoa-uc.a.run.app"
      }
      env {
        name = "CONFIG_SERVER_PORT"
        value = "443"
      }
      env {
        name = "KAKFA_BOOTSTRAP_SERVER"
        value = ""
      }
      env {
        name = "SCHEMA_REGISTRY_URI"
        value = ""
      }
      env {
        name = "MONGO_DB_URI"
        value = ""
      }
      env {
        name = "OTEL_METRICS_EXPORTER"
        value = "none"
      }
      env {
        name = "OTEL_TRACES_EXPORTER"
        value = "none"
      }
    }
  }
  traffic {
    type = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}

resource "google_cloud_run_v2_service_iam_policy" "producer-service-policy" {
  project = google_cloud_run_v2_service.producer-service.project
  location = google_cloud_run_v2_service.producer-service.location
  name = google_cloud_run_v2_service.producer-service.name
  policy_data = data.google_iam_policy.public-1.policy_data
}
