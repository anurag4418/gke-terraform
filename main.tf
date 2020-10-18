provider "google" {
  version = "3.5.0"

  credentials = file("credentials.json")

  project = "ansible-274712"
  region  = "us-central1"
  zone    = "us-central1-c"

}

resource "google_compute_network" "dev-vpc" {
  name                    = "dev-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "pub-subnet" {
  name          = "pub-subnet"
  ip_cidr_range = "10.1.0.0/16"
  region        =  var.region
  network       =  google_compute_network.dev-vpc.self_link

}

resource "google_container_cluster" "dev-cluster" {
  name       = "dev-cluster"
  location     = var.location
  network    = google_compute_network.dev-vpc.name
  subnetwork = google_compute_subnetwork.pub-subnet.name

  remove_default_node_pool = true

  initial_node_count = 1

  master_auth {
    username = ""
    password = ""
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    tags = ["http-server", "https-server"]
  }

  addons_config {

    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }

  }
}

resource "google_container_node_pool" "dev-nodepool" {
  name       = "dev-nodepooll"
  location   = var.location
  cluster    = google_container_cluster.dev-cluster.name
  node_count = 1

  node_config {
    preemptible  = false
    machine_type = "n1-standard-1"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "google_compute_firewall" "dev-cluster-allow-ssh" {
  name      = "dev-cluster-allow-ssh"
  network   = google_compute_network.dev-vpc.name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]

}
