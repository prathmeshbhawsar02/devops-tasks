# vpc

resource "aws_vpc" "my_vpc" {

    cidr_block = "10.0.0.0/16"
    tags = {
      Name= "myterraform-vpc"
    }
}

# subnet public

resource "aws_subnet" "my-public-subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.0.0/24"
    tags = {
      Name="myterraform-public-subnet"
    }
}
#  subnet private

resource "aws_subnet" "my-private-subnet"{
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.1.0/24"
    tags = {
      Name="myterraform-private-subnet"
    }
}  


#  internet gateway
resource "aws_internet_gateway" "my-igw" {
    vpc_id = aws_vpc.my_vpc.id
}
# route table for public igw

resource "aws_route_table" "my-public-rt" {
  vpc_id = aws_vpc.my_vpc.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
}

resource "aws_route_table_association" "my-public-rt-association"{
    subnet_id = aws_subnet.my-public-subnet.id
    route_table_id = aws_route_table.my-public-rt.id
}