data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

}

resource "aws_launch_template" "n26_launch_template" {
  name_prefix   = "n26-launch-template"
  image_id      = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.webserver-security-group.id]

  block_device_mappings {
    device_name = "/dev/sda1"
    
    ebs {
      volume_type = "gp3"
      volume_size = 10
      encrypted   = true
    }
  }

  user_data = filebase64("${path.module}/bootstrap_webserver.sh")

  lifecycle {
    create_before_destroy = true
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
  health_check_type    = "EC2"
  vpc_zone_identifier  = ["${aws_subnet.private-subnet-1.id}", "${aws_subnet.private-subnet-2.id}"]


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

# Target group
resource "aws_lb_target_group" "n26_alb_target_group" {
  name       = "n26-alb-target-group"
  depends_on = [aws_vpc.vpc]
  port       = 443
  protocol   = "HTTPS"
  vpc_id     = aws_vpc.vpc.id
  health_check {
    interval            = 70
    path                = "/index.html"
    port                = 443
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 60
    protocol            = "HTTPS"
    matcher             = "200,202"
  }
}
