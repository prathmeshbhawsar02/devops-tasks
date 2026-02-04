output "vpc_id" {
  value = aws_vpc.vpc1_by_module.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet_by_module.id

}

output "private_subnet_id" {
    value=aws_subnet.private_subnet_by_module.id
}
