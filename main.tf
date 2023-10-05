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

module "spark_tasks_experiencing_shuffle_spills_and_high_disk_i_o" {
  source    = "./modules/spark_tasks_experiencing_shuffle_spills_and_high_disk_i_o"

  providers = {
    shoreline = shoreline
  }
}