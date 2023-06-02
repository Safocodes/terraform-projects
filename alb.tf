resource "aws_lb" "alb" {
  name                       = "safo-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_security_group.id]
  enable_deletion_protection = false

  subnet_mapping {
    subnet_id = aws_subnet.public_subnet_az1.id

  }

  subnet_mapping {
    subnet_id = aws_subnet.public_subnet_az2.id

  }

  tags = {
    Name = "safo-alb"

  }
}

resource "aws_lb_target_group" "alb_target_group" {
  name        = "safo-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    enabled             = true
    interval            = 30
    healthy_threshold   = 5
    unhealthy_threshold = 3
    protocol            = "HTTP"
    matcher             = "200-299"
    path                = "/"
    timeout             = 5
    port                = "traffic-port"
  }
}


resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:732025887430:certificate/fe172d4a-7b60-4928-99f7-91fa4a83be08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}


resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"

    }
  }
}