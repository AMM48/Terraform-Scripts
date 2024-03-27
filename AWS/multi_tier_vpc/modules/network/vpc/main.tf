// create the VPC
resource "aws_vpc" "myVPC" {
  cidr_block = "10.16.0.0/16"

  instance_tenancy = "default"

  enable_dns_support   = true
  enable_dns_hostnames = true

  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "myVPC0"
  }
}

// create the subnets
resource "aws_subnet" "mySubnets" {
  count  = length(keys(local.subnets))
  vpc_id = aws_vpc.myVPC.id

  cidr_block        = local.subnets[keys(local.subnets)[count.index]]["cidr"]
  availability_zone = local.subnets[keys(local.subnets)[count.index]]["az"]

  map_public_ip_on_launch = split("-", keys(local.subnets)[count.index])[1] == "web" ? true : false

  ipv6_cidr_block                 = cidrsubnet(aws_vpc.myVPC.ipv6_cidr_block, 8, local.subnets[keys(local.subnets)[count.index]]["ipv6"])
  assign_ipv6_address_on_creation = true

  tags = {
    Name = keys(local.subnets)[count.index]
    Type = local.subnets[keys(local.subnets)[count.index]]["type"]
  }
}

// create the Internet Gateway
resource "aws_internet_gateway" "myIGW" {
  vpc_id = aws_vpc.myVPC.id

  tags = {
    Name = "myIGW0"
  }
}

// create the public subnets route table for Internet Gateway
resource "aws_route_table" "myRT" {
  vpc_id = aws_vpc.myVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIGW.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.myIGW.id
  }
  tags = {
    Name = "myRT0"
  }
}

// create the private subnets route table for NAT Gateway
resource "aws_route_table" "private-rt" {
  count  = length(local.web_subnet_ids)
  vpc_id = aws_vpc.myVPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw[count.index].id
  }

  tags = {
    Name = "private-rt-${count.index}"
  }
}

// associate the private subnets with the NAT Gateway route table
resource "aws_route_table_association" "private-sn-rt" {
  count          = length(local.private_subnet_ids)
  subnet_id      = aws_subnet.mySubnets[count.index].id
  route_table_id = aws_route_table.private-rt[count.index % 3].id
}

// associate the public subnets with the Internet Gateway route table
resource "aws_route_table_association" "web-sn-rt" {
  count          = length(local.web_subnet_ids)
  subnet_id      = aws_subnet.mySubnets[local.web_subnet_ids[count.index]].id
  route_table_id = aws_route_table.myRT.id
}

// create Elastic IPs for the NAT Gateways
resource "aws_eip" "nat-ips" {
  count  = local.num_of_az
  domain = "vpc"

  tags = {
    Name = "nat-ip-${count.index}"
  }

  depends_on = [aws_internet_gateway.myIGW]
}

// create the NAT Gateways
resource "aws_nat_gateway" "nat-gw" {
  count         = local.num_of_az
  allocation_id = aws_eip.nat-ips[count.index].id
  subnet_id     = aws_subnet.mySubnets[local.web_subnet_ids[count.index]].id

  tags = {
    Name = "nat-gw-${count.index}"
  }

  depends_on = [aws_internet_gateway.myIGW]
}

// create web security group
resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "Allow HTTP and HTTPS inbound traffic"
  vpc_id      = aws_vpc.myVPC.id
}

// create app security group
resource "aws_security_group" "app-sg" {
  name        = "app-sg"
  description = "Allow HTTP and HTTPS inbound traffic"
  vpc_id      = aws_vpc.myVPC.id
}

// create db security group
resource "aws_security_group" "db-sg" {
  name        = "db-sg"
  description = "Allow MySQL inbound traffic"
  vpc_id      = aws_vpc.myVPC.id
}

// create web ALB security group
resource "aws_security_group" "web-alb-sg" {
  name        = "web-alb-sg"
  description = "Allow HTTP and HTTPS inbound traffic"
  vpc_id      = aws_vpc.myVPC.id
}

// create app ALB security group
resource "aws_security_group" "app-alb-sg" {
  name        = "app-alb-sg"
  description = "Allow HTTP and HTTPS inbound traffic"
  vpc_id      = aws_vpc.myVPC.id
}

// create ingress rules with refrenced security groups
resource "aws_vpc_security_group_ingress_rule" "ingress-rules" {
  for_each                     = local.sg-rules-ingress
  security_group_id            = each.value.sg_id
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.protocol
  referenced_security_group_id = each.value.referenced_security_group_id
}

// create default ingress rules with IPv4
resource "aws_vpc_security_group_ingress_rule" "default-ipv4-ingress-rules" {
  for_each          = local.sg-default-rules-ingress
  security_group_id = each.value.sg_id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr_ipv4
}

// create default ingress rules with IPv6
resource "aws_vpc_security_group_ingress_rule" "default-ipv6-ingress-rules" {
  for_each          = local.sg-default-rules-ingress
  security_group_id = each.value.sg_id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
  cidr_ipv6         = each.value.cidr_ipv6
}

// create egress rules with refrenced security groups
resource "aws_vpc_security_group_egress_rule" "egress-rules" {
  for_each                     = local.sg-rules-egress
  security_group_id            = each.value.sg_id
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.protocol
  referenced_security_group_id = each.value.referenced_security_group_id
}

// create default egress rules with IPv4
resource "aws_vpc_security_group_egress_rule" "default-ipv4-egress-rules" {
  for_each          = local.sg-default-rules-egress
  security_group_id = each.value.sg_id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr_ipv4
}

// create default egress rules with IPv6
resource "aws_vpc_security_group_egress_rule" "default-ipv6-egress-rules" {
  for_each          = local.sg-default-rules-egress
  security_group_id = each.value.sg_id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
  cidr_ipv6         = each.value.cidr_ipv6
}
