output "ec2" {
    value = module.ec2.instance_id
}
output "vpc_id" {
    value = module.vpc.vpc_id
}