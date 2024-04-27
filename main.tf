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

variable "num_buckets" {
  type = number
  default = 2
}

variable "num_networks" {
  type = number
  default = 4
}

variable "num_subnets" {
  type = number
  default = 2
}

resource "google_storage_bucket" "bucket" {
  count = var.num_buckets
  name          = "bucket-a-freaking-unique-name-gd-${count.index}"
  storage_class = "STANDARD"
  location      = "asia-east${count.index + 1}"
  force_destroy = true
}

resource "google_compute_network" "vpc" {
  count = var.num_networks
  name = "vpc-${count.index}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  count = var.num_subnets
  name          = "subnet-${count.index}"
  region        = "asia-east2"
  network       = google_compute_network.vpc[count.index].name
  ip_cidr_range = "10.187.${count.index}.0/24"
}

resource "google_compute_firewall" "allow-http" {
  count = var.num_networks
  network = google_compute_network.vpc[count.index].name 
  
  priority = 10000
  description = "Allow HTTP traffic"
  name        = "allow-http-traffic-${count.index}"
  allow {
    protocol = "tcp"
    ports    = ["80","443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_service_accounts = ["terraform@reliable-vector-421523.iam.gserviceaccount.com"]
}
