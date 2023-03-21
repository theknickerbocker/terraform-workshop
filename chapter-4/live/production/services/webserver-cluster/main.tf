terraform {
  backend "s3" {
    key = "live/production/services/webserver-cluster/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "github.com/theknickerbocker/terraform-workshop-ch4-modules//services/webserver-cluster?ref=v0.0.1"
  
  cluster_name = "webservers-production"

  instance_type = "t2.micro"
  min_size = 2
  max_size = 10

  db_remote_state_bucket = "terraform-up-and-running-state-theknickerbocker"
  db_remote_state_key = "production/data-stores/mysql/terraform.tfstate"

}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
    scheduled_action_name = "scale-out-during-business-hours"
    min_size = 2
    max_size = 10
    desired_capacity = 10
    recurrence = "0 9 * * *"

    autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
    scheduled_action_name = "scale-in-at-night"
    min_size = 2
    max_size = 10
    desired_capacity = 2
    recurrence = "0 17 * * *"

    autoscaling_group_name = module.webserver_cluster.asg_name
}

output "alb_dns_name" {
  description = "The domain name of the load balancer"
  value = module.webserver_cluster.alb_dns_name
}
