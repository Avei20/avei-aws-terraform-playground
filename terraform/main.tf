provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "avei-ec2" {
  ami = "ami-04e914639d0cca79a"
  instance_type = "t2.micro"
}