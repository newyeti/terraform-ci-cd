terraform {
  backend "gcs" {
    bucket  = "newyeti-tf-state"
    prefix  = "terraform/state"
  }
}


provider "google" {
  project = var.project
  credentials = file(var.credential_file)
  region = var.region
  zone = var.zone
}

data "google_iam_policy" "admin" {
  binding {
    role = "roles/viewer"
    members = [
      "user:sachindra.maharjan4@gmail.com",
    ]
  }
}


data "google_iam_policy" "public-1" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}
