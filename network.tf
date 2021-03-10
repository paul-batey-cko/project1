# Declare the data source
data "aws_availability_zones" "available" {
  provider = aws.region-nginx
  state    = "available"
}

# Create public subnet in eu-west-2a
resource "aws_subnet" "public_eu_west_2a" {
  provider          = aws.region-nginx
  vpc_id            = var.vpc-id
  cidr_block        = "172.31.50.0/28"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Public Subnet eu-west-2a"
  }
}

# Update route tables to use the IGW
resource "aws_route_table" "web_vpc_public" {
  provider = aws.region-nginx
  vpc_id   = var.vpc-id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw-id
  }

  tags = {
    Name = "Public Route Table for Web VPC"
  }
}

resource "aws_route_table_association" "web_vpc_eu_west_2a_public" {
  provider       = aws.region-nginx
  subnet_id      = aws_subnet.public_eu_west_2a.id
  route_table_id = aws_route_table.web_vpc_public.id
}
