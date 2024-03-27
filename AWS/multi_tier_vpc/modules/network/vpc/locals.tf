locals {

  subnets = {
    "sn-reserve-a" = { cidr = "10.16.0.0/20", az = "us-east-1a", ipv6 = 0, type = "private" }
    "sn-reserve-b" = { cidr = "10.16.64.0/20", az = "us-east-1b", ipv6 = 4, type = "private" }
    "sn-reserve-c" = { cidr = "10.16.128.0/20", az = "us-east-1c", ipv6 = 8, type = "private" }
    "sn-web-a"     = { cidr = "10.16.48.0/20", az = "us-east-1a", ipv6 = 3, type = "public" }
    "sn-web-b"     = { cidr = "10.16.112.0/20", az = "us-east-1b", ipv6 = 7, type = "public" }
    "sn-web-c"     = { cidr = "10.16.176.0/20", az = "us-east-1c", ipv6 = 11, type = "public" }
    "sn-app-a"     = { cidr = "10.16.32.0/20", az = "us-east-1a", ipv6 = 2, type = "private" }
    "sn-app-b"     = { cidr = "10.16.96.0/20", az = "us-east-1b", ipv6 = 6, type = "private" }
    "sn-app-c"     = { cidr = "10.16.160.0/20", az = "us-east-1c", ipv6 = 10, type = "private" }
    "sn-db-a"      = { cidr = "10.16.16.0/20", az = "us-east-1a", ipv6 = 1, type = "private" }
    "sn-db-b"      = { cidr = "10.16.80.0/20", az = "us-east-1b", ipv6 = 5, type = "private" }
    "sn-db-c"      = { cidr = "10.16.144.0/20", az = "us-east-1c", ipv6 = 9, type = "private" }
  }

  web_subnet_ids     = [for i, k in keys(local.subnets) : i if local.subnets[k]["type"] == "public"]
  num_of_az          = 3
  private_subnet_ids = [for k, v in local.subnets : k if local.subnets[k]["type"] == "private"]

  sg-rules-ingress = {
    "0" = {
      sg_id                        = aws_security_group.web-sg.id,
      from_port                    = 80,
      to_port                      = 80,
      protocol                     = "tcp",
      referenced_security_group_id = aws_security_group.web-alb-sg.id
    },
    "1" = {
      sg_id                        = aws_security_group.app-sg.id,
      from_port                    = 80
      to_port                      = 80
      protocol                     = "tcp"
      referenced_security_group_id = aws_security_group.app-alb-sg.id
    },

    "2" = {
      sg_id                        = aws_security_group.db-sg.id,
      from_port                    = 3306
      to_port                      = 3306
      protocol                     = "tcp"
      referenced_security_group_id = aws_security_group.app-sg.id
    },
  }

  sg-default-rules-ingress = {
    "0" = {
      sg_id     = aws_security_group.web-alb-sg.id,
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
      cidr_ipv4 = "0.0.0.0/0"
      cidr_ipv6 = "::/0"
    },
    "1" = {
      sg_id     = aws_security_group.web-alb-sg.id,
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
      cidr_ipv4 = "0.0.0.0/0"
      cidr_ipv6 = "::/0"
    },
    "2" = {
      sg_id     = aws_security_group.app-alb-sg.id,
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
      cidr_ipv4 = "0.0.0.0/0"
      cidr_ipv6 = "::/0"
    },
    "3" = {
      sg_id     = aws_security_group.app-alb-sg.id,
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
      cidr_ipv4 = "0.0.0.0/0"
      cidr_ipv6 = "::/0"
    },
  }

  sg-rules-egress = {
    "0" = {
      sg_id                        = aws_security_group.app-sg.id,
      from_port                    = 3306
      to_port                      = 3306
      protocol                     = "tcp"
      referenced_security_group_id = aws_security_group.db-sg.id
    },
  }
  sg-default-rules-egress = {
    "0" = {
      sg_id     = aws_security_group.db-sg.id,
      from_port = -1
      to_port   = -1
      protocol  = "-1"
      cidr_ipv4 = "0.0.0.0/0"
      cidr_ipv6 = "::/0"
    },
    "1" = {
      sg_id     = aws_security_group.web-alb-sg.id,
      from_port = -1
      to_port   = -1
      protocol  = "-1"
      cidr_ipv4 = "0.0.0.0/0"
      cidr_ipv6 = "::/0"
    },
    "2" = {
      sg_id     = aws_security_group.app-alb-sg.id,
      from_port = -1
      to_port   = -1
      protocol  = "-1"
      cidr_ipv4 = "0.0.0.0/0"
      cidr_ipv6 = "::/0"
    },
    "3" = {
      sg_id     = aws_security_group.app-sg.id,
      from_port = -1
      to_port   = -1
      protocol  = "-1"
      cidr_ipv4 = "0.0.0.0/0"
      cidr_ipv6 = "::/0"
    },
    "4" = {
      sg_id     = aws_security_group.web-sg.id,
      from_port = -1
      to_port   = -1
      protocol  = "-1"
      cidr_ipv4 = "0.0.0.0/0"
      cidr_ipv6 = "::/0"
    },
  }
}

