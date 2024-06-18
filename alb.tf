# Application LB
resource "aws_lb" "n26_alb" {
  name               = "n26_alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-security-group.id]
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]

  tags = {
    name    = "n26 alb"
  }
}

# ALB Listener 
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.n26_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.n26_alb_target_group.arn
  }
}
