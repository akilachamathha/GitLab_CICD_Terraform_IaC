# Create a lambda function for vertical scaling up. 
resource "aws_lambda_function" "ecs_vertical_scaler_up" {
  function_name = "ECSVerticalScalerUP"
  runtime       = "nodejs18.x"
  handler       = "ECSVerticalScalerUP.handler"       # Lambda function handler name
  role          = aws_iam_role.lambda_exec_role.arn
  filename      = "lambda/ECSVerticalScalerUP.zip"    # Path to the lambda function zip file
  source_code_hash = filebase64sha256("lambda/ECSVerticalScalerUP.zip")
  depends_on = [aws_cloudwatch_log_group.lambda_log_group_up]   # Assign the log group for the lambda function

  environment {     # Assign environment variables for the lambda function
    variables = {
      ECS_CLUSTER = aws_ecs_cluster.webapp.name
      ECS_SERVICE = aws_ecs_service.webapp.name
    }
  }
}


resource "aws_lambda_function" "ecs_vertical_scaler_down" {
  function_name = "ECSVerticalScalerDown"
  runtime       = "nodejs18.x"
  handler       = "ECSVerticalScalerDown.handler"
  role          = aws_iam_role.lambda_exec_role.arn
  filename      = "lambda/ECSVerticalScalerDown.zip"
  source_code_hash = filebase64sha256("lambda/ECSVerticalScalerDown.zip")
  depends_on = [aws_cloudwatch_log_group.lambda_log_group_down]   # Assign the log group for the lambda function

  environment {     # Assign environment variables for the lambda function
    variables = {
      ECS_CLUSTER = aws_ecs_cluster.webapp.name
      ECS_SERVICE = aws_ecs_service.webapp.name
    }
  }
}