output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "asg_name" {
  value = module.ec2_asg.asg_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
