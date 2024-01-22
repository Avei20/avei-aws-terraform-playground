resource "aws_instance" "avei-ec2" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.landing_zone_subnet.id 

  tags = {
    Name = "avei-ec2"
  }
}
