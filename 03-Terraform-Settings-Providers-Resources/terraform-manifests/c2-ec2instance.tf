# Resource: EC2 Instance
resource "aws_instance" "z3n-ec2vm" {
  ami = "ami-0d26eb3972b7f8c96"
  instance_type = "t3.micro"
  user_data = file("${path.module}/app1-install.sh")
  tags = {
    "Name" = "EC2 Demo"
  }
}  
