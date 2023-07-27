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
      image = "us-central1-docker.pkg.dev/newyeti/images/newyeti-producer:v0.3.2"

      resources {
        limits = {
          # CPU usage limit
          # https://cloud.google.com/run/docs/configuring/cpu
          #cpu = "1000m" # 1 vCPU

          # Memory usage limit (per container)
          # https://cloud.google.com/run/docs/configuring/memory-limits
          memory = "1024Mi"
        }
      } 
      ports {
        container_port = 4000
      }
      env {
        name = "SPRING_PROFILES_ACTIVE"
        value = "gcp"
      }
      env {
        name = "SPRING_APPLICATION_JSON"
        value = "{\"kafka.producer.send.enabled\":\"false\"}"
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
        name = "MONGODB_HOST"
        value = "uefa-cluster-0.rj6sj7h.mongodb.net"
      }
      env {
        name = "MONGODB_USERNAME"
        value = "cruser"
      }
       env {
        name = "MONGODB_DATABASE"
        value = "football"
      }
      env {
        name = "MONGODB_PASSWORD"
        value_source {
          secret_key_ref {
            version = "latest"
            secret = "mongodb-password"
          }
        }
      }
     
      env {
        name = "RAPID_API_KEYS"
        value_source {
          secret_key_ref {
            version = "1"
            secret = "rapid-api-keys"
          }
        }
      }

      env {
        name = "REDIS_HOST"
        value = "gusc1-sought-glider-30297.upstash.io"
      }

      env {
        name = "REDIS_PORT"
        value = "30297"
      }

      env {
        name = "REDIS_PASSWORD"
        value_source {
          secret_key_ref {
            version = "latest"
            secret = "redis-password"
          }
        }
      }

      env {
        name = "KAKFA_BOOTSTRAP_SERVER"
        value = "dory.srvs.cloudkafka.com:9094"
      }
      env {
        name = "CLOUDKARAFKA_USERNAME"
        value = "luzpguyd"
      }
      env {
        name = "CLOUDKARAFKA_PASSWORD"
        value = ""
      }
      env {
        name = "SCHEMA_REGISTRY_URI"
        value = "https://schemaregistry.cloudkarafka.com"
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
