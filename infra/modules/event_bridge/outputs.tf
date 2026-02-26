output "lambda_schedule" {
  value = aws_cloudwatch_event_rule.lambda_schedule.name
}

output "rule_arn" {
  value = aws_cloudwatch_event_rule.lambda_schedule.arn
}