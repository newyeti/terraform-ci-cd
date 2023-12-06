variable "project" {}
variable "credential_file" {}

variable "region" {
  type = string
  default = "us-central1"
}

variable "zone" {
  type = string
  default = "us-central1-a"
}

variable "os_image" {
  type = string
  default = "ubuntu-minimal-2204-jammy-arm64-v20230617"
  description = "Os image type"
}

variable "vm_params" {
  type = object({
    name = string
    machine_type = string
    zone = string
    allow_stopping_for_update = bool
  })
  description = "vm parameters"
  default = {
    name = "terraform-instance"
    machine_type = "f1-micro"
    zone = "us-central1-a"
    allow_stopping_for_update = true
  }

  validation {
    condition = length(var.vm_params.name) > 3
    error_message = "VM name must be at least 4 characters"
  }
}

variable "network_params" {
  type = object({
    name = string
    auto_create_subnetworks = bool 
  })
  description = "network parameters"
  default = {
    name = "terraform-network"
    auto_create_subnetworks = false
  }
}

variable "subnetwork_params" {
  type = object({
    name = string
    ip_cidr_range = string
    region = string 
  })
  description = "subnetwork parameters"
  default = {
    name = "terraform-subnetwork"
    ip_cidr_range = "10.20.0.0/16"
    region = "us-central1"
  }
}

variable "ps_git_tag" {
  type = string
  description = "This is a git tag of artifact to be deployed"

  default = "latest"
}

variable "footysync_image_tag" {
  type = string
  description = "This is a image tag for datasync service"

  default = "v0.1.1"
  
}