module "vpc" {
  source = "../../modules/vpc"

  project_name = "terraform-prod-project"
  environment  = "prod"
  vpc_cidr     = "10.2.0.0/16"

  public_subnets = {
    "ap-south-1a" = "10.2.1.0/24"
    "ap-south-1b" = "10.2.2.0/24"
  }

  private_subnets = {
    "ap-south-1a" = "10.2.11.0/24"
    "ap-south-1b" = "10.2.12.0/24"
  }
}

module "security_group" {
  source = "../../modules/security-group"

  project_name = "terraform-prod-project"
  environment  = "prod"
  vpc_id       = module.vpc.vpc_id
}


module "alb" {
  source = "../../modules/alb"

  project_name      = "terraform-prod-project"
  environment       = "prod"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_group.alb_sg_id
}


module "ec2_asg" {
  source = "../../modules/ec2-asg"

  project_name       = "terraform-prod-project"
  environment        = "prod"
  private_subnet_ids = module.vpc.private_subnet_ids
  app_sg_id          = module.security_group.app_sg_id
  target_group_arn   = module.alb.target_group_arn
  instance_type      = "t3.micro"
}


module "rds" {
  source = "../../modules/rds"

  project_name       = "terraform-prod-project"
  environment        = "prod"
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = module.security_group.rds_sg_id
  db_username        = "appuser"
  db_password        = var.db_password
}


module "secrets" {
  source = "../../modules/secrets"

  project_name = "terraform-prod-project"
  environment  = "prod"

  db_username = module.rds.db_username
  db_password = var.db_password
  db_endpoint = module.rds.db_endpoint
  db_name     = module.rds.db_name
}
