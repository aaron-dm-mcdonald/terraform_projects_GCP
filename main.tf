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
  project = "hardy-beach-417021"
  region = "asia-east2"
  zone = "asia-east2-a"
  credentials = "hardy-beach-417021-de8136813a47.json"
}

