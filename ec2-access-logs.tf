data "aws_iam_policy_document" "cloudwatch_logs_policy" {
  statement {
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "ec2-cloudwatch-logs-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })

  inline_policy {
    name   = "cloudwatch-logs-policy"
    policy = data.aws_iam_policy_document.cloudwatch_logs_policy.json
  }
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-cloudwatch-logs-profile"
  role = aws_iam_role.ec2_role.name
}