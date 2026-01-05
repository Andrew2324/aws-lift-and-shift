variable "log_retention_days" {
  type    = number
  default = 7
}

resource "aws_cloudwatch_log_group" "apache_access" {
  name              = "/aws/liftshift/apache/access"
  retention_in_days = var.log_retention_days
}

resource "aws_cloudwatch_log_group" "apache_error" {
  name              = "/aws/liftshift/apache/error"
  retention_in_days = var.log_retention_days
}

resource "aws_cloudwatch_log_group" "system_messages" {
  name              = "/aws/liftshift/system/messages"
  retention_in_days = var.log_retention_days
}
