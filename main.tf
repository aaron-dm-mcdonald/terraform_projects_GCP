terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.25.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = "reliable-vector-421523"
  region = "asia-east2"
  zone = "asia-east2-a"
  credentials = "reliable-vector-421523-d2cbe344cb8a.json"
}


resource "google_storage_bucket" "bucket1" {
  name          = "dont-copy-this-test-test-test1"
  storage_class = "STANDARD"
  location      = "asia-east1"
  force_destroy = true

}

resource "google_storage_bucket" "bucket2" {
  name          = "dont-copy-this-test-test-test2"
  storage_class = "STANDARD"
  location      = "asia-east2"
  force_destroy = true

}


resource "google_compute_network" "vpc" {
  count = 2
  name = "vpc-${count.index}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  count = 2
  name          = "subnet-${count.index}"
  region        = "asia-east2"
  network       = google_compute_network.vpc[count.index].name
  ip_cidr_range = "10.187.${count.index}.0/24"
}

resource "google_compute_firewall" "allow-http" {
  count = 2
  name        = "allow-http-traffic-${count.index}"
  network     = google_compute_network.vpc[count.index].name
  allow {
    protocol = "tcp"
    ports    = ["80","443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_service_accounts = ["terraform@reliable-vector-421523.iam.gserviceaccount.com"]
}