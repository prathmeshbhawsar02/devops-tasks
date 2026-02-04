resource "aws_vpc" "vpc1_by_module" {
    cidr_block = var.vpc_cidr
    tags = merge(
        var.tags,
        { Name="vpc1-by-module"}
    )
}

resource "aws_subnet" "public_subnet_by_module" {
    vpc_id = aws_vpc.vpc1_by_module.id
    cidr_block = var.public_subnet_cidr
    map_public_ip_on_launch = true
    tags = merge(
        var.tags,
        { Name="public-subnet-by-module"}
    )
}

resource "aws_subnet" "private_subnet_by_module" {
    vpc_id = aws_vpc.vpc1_by_module.id
    cidr_block = var.private_vpc_subnet
    tags = merge(
        var.tags,
        { Name="private-subnet-by-module"}
    )
}

resource "aws_internet_gateway" "igw_by_module" {
    vpc_id = aws_vpc.vpc1_by_module.id
    tags = merge(
        var.tags,
        { Name="igw-by-module"}
    )   
}

resource "aws_route_table" "public_rt_by_module" {
    vpc_id = aws_vpc.vpc1_by_module.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_by_module.id
    }
    tags = merge(
        var.tags,
        { Name = "public-rt-by-module"}
    )
}

resource "aws_route_table_association" "public_rt_association_by_module" {
    subnet_id = aws_subnet.public_subnet_by_module.id
    route_table_id = aws_route_table.public_rt_by_module.id
}