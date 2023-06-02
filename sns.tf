resource "aws_sns_topic" "safo_updates" {
  name = "safo-updates-topic"

}

# create an sns topic
resource "aws_sns_topic_subscription" "safo_updates" {
  topic_arn = aws_sns_topic.safo_updates.arn
  protocol  = "email"
  endpoint  = "lekanaws@gmail.com"
} 