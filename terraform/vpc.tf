# Create default VPC and subnets
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Access the availability zones in the region
data "aws_availability_zones" "available" {}

# Create public subnets in different AZs
resource "aws_subnet" "public" {
  count                   = 2       # Number of public subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
}