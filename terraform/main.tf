resource "aws_instance" "ub_ec2" {
  ami           = var.ami_ubuntu
  instance_type = var.instance_type
  tags = {
    Name = "ec2 instance"
  }
}
