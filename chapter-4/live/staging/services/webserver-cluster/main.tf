terraform {
  backend "s3" {
    key = "live/staging/services/webserver-cluster/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "github.com/theknickerbocker/terraform-workshop-ch4-modules//services/webserver-cluster?ref=v0.0.1"
  
  cluster_name = "webservers-staging"

  instance_type = "t2.micro"
  min_size = 2
  max_size = 10

  db_remote_state_bucket = "terraform-up-and-running-state-theknickerbocker"
  db_remote_state_key = "staging/data-stores/mysql/terraform.tfstate"
}

output "alb_dns_name" {
  description = "The domain name of the load balancer"
  value = module.webserver_cluster.alb_dns_name
}
