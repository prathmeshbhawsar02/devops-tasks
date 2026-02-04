provider "aws" {
    region = var.region

}


module "vpc" {
    source = "./modules/vpc"
    vpc_cidr = var.vpc_cidr
    public_subnet_cidr = var.public_subnet_cidr
    private_vpc_subnet = var.private_subnet_cidr
    az = var.az

    tags = {
        Environment=var.env
    }
}

module "sg" {
    source = "./modules/sg"
    vpc_id = module.vpc.vpc_id

}


module "ec2" {
    source = "./modules/ec2"

    ami_id = var.ami_id
    instance_type = var.instance_type
    subnet_id = module.vpc.public_subnet_id
    vpc_id = module.vpc.public_subnet_id
    sg=module.sg.sg_id



    tags = {
      Environment=var.env
    }
}


