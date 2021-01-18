terraform {
  # This module is now only being tested with Terraform 0.13.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 0.13.x code.
  backend "gcs" {}
  required_version = "= 0.14.4"

  required_providers {
    google      = "= 3.25.0"
    google-beta = "~> 3.43.0"
    null = {
      source = "hashicorp/null"
    }
  }
}