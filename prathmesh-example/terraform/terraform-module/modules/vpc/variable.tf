variable "vpc_cidr" {
    type= string
}

variable "public_subnet_cidr" {
    type = string
}

variable "private_vpc_subnet" {
    type = string
}

variable "az" {
    type=string
    default = "ap_south_1b"
}

variable "tags" {
    type = map(string)
}