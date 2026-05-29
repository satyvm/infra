terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

provider "google" {
  project = "project-96345559-d949-4b8c-91b"
  region  = "us-central1"
}

resource "google_compute_network" "default" {
  name = "learn-network"

  auto_create_subnetworks  = false
  enable_ula_internal_ipv6 = true
}

resource "google_compute_subnetwork" "default" {
  name = "learn-subnetwork"

  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"

  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "EXTERNAL" # Change to "EXTERNAL" if creating an external loadbalancer

  network = google_compute_network.default.id
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "10.1.0.0/20"
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "10.2.0.0/20"
  }
}

resource "google_container_cluster" "default" {
  name = "learn-standard-cluster"

  location                 = "us-central1-b"
  enable_l4_ilb_subsetting = true
  remove_default_node_pool = true
  initial_node_count = 1
  datapath_provider        = "ADVANCED_DATAPATH" 

  network    = google_compute_network.default.id
  subnetwork = google_compute_subnetwork.default.id

  ip_allocation_policy {
    stack_type                    = "IPV4_IPV6"
    services_secondary_range_name = google_compute_subnetwork.default.secondary_ip_range[0].range_name
    cluster_secondary_range_name  = google_compute_subnetwork.default.secondary_ip_range[1].range_name
  }

  gateway_api_config {
    channel = "CHANNEL_STANDARD"
  }
  workload_identity_config {
    workload_pool = "project-96345559-d949-4b8c-91b.svc.id.goog"
  }
  deletion_protection = false
}

resource "google_container_node_pool" "default_spot_nodes" {
  name       = "learn-node-pool"
  location   = "us-central1-b"
  cluster    = google_container_cluster.default.name
  node_count = 2

  node_config {
    spot  = true
    machine_type = "e2-standard-2"
  }
}