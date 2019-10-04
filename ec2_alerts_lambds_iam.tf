resource "aws_iam_role_policy" "ec2_alert_policy" {
  name = "ec2_alert_policy"
  role = "${aws_iam_role.ec2_alert_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sns:Publish"
      ],
      "Effect": "Allow",
      "Resource": "${aws_sns_topic.ec2_alerts.arn}"
    },
    {
      "Action": "logs:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "ec2_alert_role" {
  name = "ec2_alert_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}