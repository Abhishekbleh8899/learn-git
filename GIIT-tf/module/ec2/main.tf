resource "aws_instance" "main" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile        = var.iam_instance_profile
  key_name = aws_key_pair.my_key.key_name
  tags = {
    Name = var.name
  }
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
}

resource "aws_key_pair" "my_key" {
  key_name   = var.key_name
  public_key = tls_private_key.this.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content         = tls_private_key.this.private_key_pem
  filename        = "${path.module}/${var.key_name}.pem"
  file_permission = "0400"
}