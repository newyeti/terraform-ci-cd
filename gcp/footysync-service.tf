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

      env {
        name = "MONGO.MONGO_HOSTNAME"
        value = "uefa-cluster-0.rj6sj7h.mongodb.net"
      }
      env {
        name = "MONGO.MONGO_USERNAME"
        value = "cruser"
      }
      env {
        name = "MONGO.MONGO_PASSWORD"
        value_source {
          secret_key_ref {
            version = "latest"
            secret = "mongodb-password"
          }
        }
      }
      env {
        name = "MONGO.MONGO_DB"
        value = "football"
      }

      env {
        name = "BIGQUERY.BIGQUERY_CREDENTIAL"
        value_source {
          secret_key_ref {
            version = "latest"
            secret = "newyeti_bq_credentials"
          }
        }
      }

      env {
        name = "REDIS.REDIS_HOST"
        value = "gusc1-sought-glider-30297.upstash.io"
      }

      env {
        name = "REDIS.REDIS_PORT"
        value = "30297"
      }

      env {
        name = "REDIS.REDIS_PASSWORD"
        value_source {
          secret_key_ref {
            version = "latest"
            secret = "redis-password"
          }
        }
      }
      env {
        name = "REDIS.REDIS_SSL_ENABLED"
        value = "True"
      }

      env {
        name = "KAFKA.KAFKA_BOOTSTRAP_SERVERS"
        value = "legible-reptile-12962-us1-kafka.upstash.io:9092"
      }
      env {
        name = "KAFKA.KAFKA_USERNAME"
        value = "bGVnaWJsZS1yZXB0aWxlLTEyOTYyJDDCdDTjhIG87z8kcwB8RDj4ycMf835NAsA"
      }
      env {
        name = "KAFKA.KAFKA_PASSWORD"
        value_source {
          secret_key_ref {
            version = "1"
            secret = "kafka_password"
          }
        }
      }

      env {
        name = "rapid_api.RAPID_API_KEYS"
        value_source {
          secret_key_ref {
            version = "1"
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
