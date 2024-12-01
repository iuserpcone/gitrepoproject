resource "aws_instance" "web1" {
  ami                    = "ami-013168dc3850ef002"
  instance_type          = "t2.micro"
  key_name               = "pnewkey"
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  subnet_id              = aws_subnet.mysubnet.id
  # Enable a public IP address for the instance
  associate_public_ip_address = true
  count                       = 2
  tags = {
    Name = "Gangtoka.${count.index + 1}"
  }
}

# Create a VPC
resource "aws_vpc" "myvpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    name = "my terraformvpc"
  }
}
# Create a subnet within the VPC
resource "aws_subnet" "mysubnet" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.0.0/24"
  tags = {
    name = "myterraformsbnta"
  }
}


# Create a igw
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "myigw"
  }
}


# Create a route table
resource "aws_route_table" "myroteterraform" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }
  tags = {
    Name = "my route table"

  }
}
# Route table association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.myroteterraform.id
}

# Create a security group for the EC2 instance
resource "aws_security_group" "my_security_group" {
  name        = "my_security_group"
  description = "Allow inbound SSH and HTTP traffic"
  vpc_id      = aws_vpc.myvpc.id


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# create an internet ip
resource "aws_eip" "example" {
  vpc = true
  tags = {
    Name = "example-eip"
  }
}
output "Public_ip" {
  value = aws_eip.example.public_ip
}
















