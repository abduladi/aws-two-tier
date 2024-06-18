# # Application LB
# resource "aws_lb" "n26_alb" {
#   name               = "n26-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb-security-group.id]
#   subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
  

#   tags = {
#     name    = "n26 alb"
#   }
# }

# # ALB Listener 

# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.n26_alb.arn
#   port              = "443"
#   protocol          = "HTTPS"
  
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.server-cert

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.n26_alb_target_group.arn
#   }
# }

# # Create WAF with some rules for the ALB
# resource "aws_wafv2_web_acl" "alb_waf_acl" {
#   name        = "alb-waf-acl"
#   scope       = "REGIONAL"
#   description = "WAF ACL for application load balancer"
#   default_action {
#     allow {}
#   }
#   visibility_config {
#     sampled_requests_enabled = true
#     cloudwatch_metrics_enabled = true
#     metric_name = "N26ALBWebACL"
#   }
#   rule {
#     name     = "rate-limit-rule"
#     priority = 1
#     action {
#       block {}
#     }
#     statement {
#       rate_based_statement {
#         limit              = 1000
#         aggregate_key_type = "IP"
#       }
#     }
#     visibility_config {
#       sampled_requests_enabled = true
#       cloudwatch_metrics_enabled = true
#       metric_name = "rateLimitRule"
#     }
#   }
# }

# # associate waf with ALB
# resource "aws_wafv2_web_acl_association" "alb_waf_acl_association" {
#   resource_arn = aws_lb.n26_alb.arn
#   web_acl_arn  = aws_wafv2_web_acl.alb_waf_acl.arn
# }
