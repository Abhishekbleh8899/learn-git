output "subnet-config" {
  value = {
    public_subnet  = { for key, subnet in local.public_subnet : key => aws_subnet.main[key].id }
    private_subnet = { for key, subnet in local.private_subnet : key => aws_subnet.main[key].id }
  }
}

output "vpc_id" {
  value = aws_vpc.main.id
}