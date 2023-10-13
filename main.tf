terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "time_synchronization_issues_causing_spark_job_failures" {
  source    = "./modules/time_synchronization_issues_causing_spark_job_failures"

  providers = {
    shoreline = shoreline
  }
}