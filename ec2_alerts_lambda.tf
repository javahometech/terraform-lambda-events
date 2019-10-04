data "archive_file" "ec2_alerts" {
  type        = "zip"
  source_file = "./scripts/ec2_alerts.py"
  output_path = "./scripts/ec2_alerts.zip"
}
resource "aws_lambda_function" "ec2_alerts" {
  filename      = "./scripts/ec2_alerts.zip"
  function_name = "ec2Alerts"
  role          = "${aws_iam_role.ec2_alert_role.arn}"
  handler       = "ec2_alerts.send_alerts"

#   source_code_hash = "${filebase64sha256("scripts/ec2_alerts.zip")}"

  runtime = "python3.6"

  environment {
    variables = {
      TOPIC_ARN = "${aws_sns_topic.ec2_alerts.arn}"
    }
  }
}

resource "aws_cloudwatch_event_rule" "ec2_alerts" {
  name        = "ec2_alerts"
  description = "Capture each AWS Console Sign In"

  event_pattern = <<PATTERN
{
  "source": [ "aws.ec2" ],
  "detail-type": [ "EC2 Instance State-change Notification" ],
  "detail": {
    "state": [ "stopping" ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "ec2_alerts" {
  target_id = "ec2_alerts"
  rule      = "${aws_cloudwatch_event_rule.ec2_alerts.name}"
  arn       = "${aws_lambda_function.ec2_alerts.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.ec2_alerts.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.ec2_alerts.arn}"
}
