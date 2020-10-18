output "endpoint" {
  value = google_container_cluster.dev-cluster.endpoint
}

output "master_version" {
  value = google_container_cluster.dev-cluster.master_version
}