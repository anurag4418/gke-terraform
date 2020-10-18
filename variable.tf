variable "name" {
  default = "dev-cluster"
}

variable "project" {
  default = "ansible-274712"
}

variable "location" {
  default = "us-central1"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "initial_node_count" {
  default = 1
}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "gcp_network" {
  default = "dev-vpc"
}

variable "gcp_subnetwork" {
  default = "pub-subnet"
}