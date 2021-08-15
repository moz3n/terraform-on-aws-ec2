# Availability Zones Datasource
data "aws_availability_zones" "z3n-azones" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}
// data.aws_availability_zones.z3n-zones.names

# EC2 Instance
resource "aws_instance" "z3n-ec2vm" {
  ami = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type
  user_data = file("${path.module}/app1-install.sh")
  key_name = var.instance_keypair
  vpc_security_group_ids = [ aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id ]
  # Create EC2 Instance in all Availabilty Zones of a VPC  
  for_each = toset(data.aws_availability_zones.z3n-azones.names)
  availability_zone = each.key # You can also use each.value because for list items each.key == each.value
  tags = {
  "Name" = "For-each-Demo-${each.value}"
 }
}