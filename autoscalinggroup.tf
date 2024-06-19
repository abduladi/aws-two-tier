resource "aws_launch_template" "n26_launch_template" {
  name_prefix   = "n26-launch-template"
  image_id      = "ami-0eaf7c3456e7b5b68"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.webserver-security-group.id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_instance_profile.arn
  }

  user_data = filebase64("${path.module}/bootstrap_webserver.sh")

  lifecycle {
    create_before_destroy = true
  }

  tags = {
      Name = "n26 autoscaled"
    }
}




# ASG
resource "aws_autoscaling_group" "n26_asg" {
  name                 = "n26_asg"
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  force_delete         = true
  depends_on           = [aws_lb.n26_alb]
  target_group_arns    = ["${aws_lb_target_group.n26_alb_target_group.arn}"]
  health_check_type    = "ELB"
  vpc_zone_identifier  = ["${aws_subnet.private-subnet-1.id}", "${aws_subnet.private-subnet-2.id}"]
  wait_for_capacity_timeout = "20m"


  launch_template {
    id      = aws_launch_template.n26_launch_template.id
    version = aws_launch_template.n26_launch_template.latest_version
  }

  tag {
    key                 = "Name"
    value               = "n26_asg"
    propagate_at_launch = true
  }

}

# scaling policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  autoscaling_group_name = aws_autoscaling_group.n26_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "scale_up" {
  alarm_description   = "Monitors CPU utilization for N26 ASG"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  alarm_name          = "N26_scale_up"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "70"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.n26_asg.name
  }
}


# scale down policy
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down"
  autoscaling_group_name = aws_autoscaling_group.n26_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_description   = "Monitors CPU utilization for N26 ASG"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  alarm_name          = "N26_scale_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "20"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.n26_asg.name
  }
}



# Target group
resource "aws_lb_target_group" "n26_alb_target_group" {
  name       = "n26-alb-target-group"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.vpc.id
  health_check {
    interval            = 70
    path                = "/index.html"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    protocol            = "HTTP"
    matcher             = "200,202"
  }
}