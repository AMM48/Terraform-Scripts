resource "aws_lb_target_group" "web-tg" {
  name        = "web-tg"
  protocol    = "HTTP"
  port        = 80
  target_type = "instance"
  vpc_id      = var.vpc-id

  health_check {
    enabled  = true
    path     = "/"
    protocol = "HTTP"
    port     = "80"
  }
}

resource "aws_lb" "web-alb" {
  name                             = "web-alb"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = var.web-alb-sg
  subnets                          = [for subnet in var.subnets : subnet.id if contains(["sn-web-a", "sn-web-b", "sn-web-c"], subnet.tags["Name"])]
  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false
  enable_http2                     = true
  ip_address_type                  = "dualstack"
}

resource "aws_lb_listener" "web-alb-http-listener" {
  load_balancer_arn = aws_lb.web-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

}

resource "aws_lb_listener" "web-alb-https-listener" {
  load_balancer_arn = aws_lb.web-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.acm-cert-arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-tg.arn
  }
}

resource "aws_lb_target_group" "app-tg" {
  name        = "app-tg"
  protocol    = "HTTP"
  port        = 80
  target_type = "instance"
  vpc_id      = var.vpc-id

  health_check {
    enabled  = true
    path     = "/health.php"
    protocol = "HTTP"
    port     = "80"
  }
}

resource "aws_lb" "app-alb" {
  name                             = "app-alb"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = var.app-alb-sg
  subnets                          = [for subnet in var.subnets : subnet.id if contains(["sn-web-a", "sn-web-b", "sn-web-c"], subnet.tags["Name"])]
  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false
  enable_http2                     = true
  ip_address_type                  = "dualstack"
}

resource "aws_lb_listener" "app-alb-http-listener" {
  load_balancer_arn = aws_lb.app-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "app-alb-https-listener" {
  load_balancer_arn = aws_lb.app-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.acm-cert-arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }
}
