# Create a CloudWatch log group for ECS
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${local.prefix}"
  retention_in_days = 30  # Retention period for logs
}

# Create a CloudWatch log group for ecs_vertical_scaler_up Lambda
resource "aws_cloudwatch_log_group" "lambda_log_group_up" {
  name              = "/aws/lambda/ECSVerticalScalerUP"
  retention_in_days = 30
}

# Create a CloudWatch log group for ecs_vertical_scaler_down Lambda
resource "aws_cloudwatch_log_group" "lambda_log_group_down" {
  name              = "/aws/lambda/ECSVerticalScalerDown"
  retention_in_days = 30
}
