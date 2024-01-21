# Create the Landing Zone VPC
resource "aws_vpc" "landing_zone" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Landing Zone"
  }
}

# Landing Zone Subnet
resource "aws_subnet" "landing_zone_subnet-2" {
  vpc_id = aws_vpc.landing_zone.id
  cidr_block = "10.0.0.0/24"
}

# Create the Application VPC
resource "aws_vpc" "application" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "Application"
  }
}

# Application Subnet
resource "aws_subnet" "application_subnet" {
  vpc_id = aws_vpc.application.id
  cidr_block = "10.1.0.0/24"
}

# Create the Transit Gateway
resource "aws_ec2_transit_gateway" "transit_gateway" {
  description = "Transit Gateway"
}

# Security Group for Lambda to access RDS
resource "aws_security_group" "database" {
  name = "avei-database"
  vpc_id = aws_vpc.application.id

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["10.1.0.0/24"]
    security_groups = [aws_security_group.lambda.id]
  }

  egress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["10.1.0.0/24"]
  }
}

resource "aws_security_group" "lambda" {
  vpc_id = aws_vpc.application.id
  name = "avei-sg-lambda"

  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_db_subnet_group" "database" {
#   name = "avei-database"
#   subnet_ids = [aws_subnet.application_subnet.id]
# }


# Attach the Landing Zone VPC to the Transit Gateway
# resource "aws_route" "landing_zone_tgw" {
#   route_table_id = aws_subnet.landing_zone_subnet.id
#   destination_cidr_block = ""
#   transit_gateway_id = aws_ec2_transit_gateway.transit_gateway.id
#   vpc_id             = aws_vpc.landing_zone.id
# }

# # Attach the Application VPC to the Transit Gateway
# resource "aws_ec2_transit_gateway_vpc_attachment" "application_attachment" {
#   transit_gateway_id = aws_ec2_transit_gateway.transit_gateway.id
#   vpc_id             = aws_vpc.application.id
# }
