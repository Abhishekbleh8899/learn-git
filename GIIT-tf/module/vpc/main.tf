resource "aws_vpc" "main" {
  cidr_block = var.vpc-config.cidr_block
  tags = {
    Name = var.vpc-config.name
  }
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  for_each          = var.subnet-config
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}
locals {
  public_subnet = {
    for key, config in var.subnet-config : key => config if config.public == true
  }
  private_subnet = {
    for key, config in var.subnet-config : key => config if config.public == false
  }
}
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  count  = length(local.public_subnet) > 0 ? 1 : 0
}

resource "aws_route_table" "main" {
  count  = length(local.public_subnet) > 0 ? 1 : 0
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main[0].id
  }

}
resource "aws_route_table" "private" {
  count  = length(local.private_subnet) > 0 ? 1 : 0
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[0].id
  }
}

resource "aws_route_table_association" "main" {
  for_each       = local.public_subnet
  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.main[0].id
}

resource "aws_route_table_association" "private" {
  for_each       = local.private_subnet
  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.private[0].id
}

resource "aws_nat_gateway" "main" {
  count             = length(local.private_subnet) > 0 ? 1 : 0
  connectivity_type = "private"
  subnet_id         = aws_subnet.main[keys(local.public_subnet)[0]].id

}
