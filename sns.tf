resource "aws_sns_topic" "ec2_alerts" {
  name = "ec2_alerts"
}

resource "aws_sns_topic_subscription" "ec2_alerts" {
  topic_arn = "${aws_sns_topic.ec2_alerts.arn}"
  protocol  = "sms"
  endpoint  = "+919972144990"
}
