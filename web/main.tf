resource "aws_instance" "ec2" {
  ami             = "ami-df5de735"
  instance_type   = "t2.micro"
  security_groups = [var.sg]
  subnet_id       = var.sn

  tags = {
    Name = "ec2"
  }
}
