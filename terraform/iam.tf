# Create IAM roles and policies for ECS task execution
resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Create IAM roles and policies for Lambda functions
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambdaEcsScalerRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Create IAM policy for Lambda to read and write task definition and scale ECS services
resource "aws_iam_policy" "ecs_scaler_policy" {
  name        = "ECSVerticalScalerPolicy"
  description = "Allows Lambda to scale ECS services"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition",
          "ecs:UpdateService"
        ],
        Resource = "*"
      },
       {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
    }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_ecs_permissions" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.ecs_scaler_policy.arn
}

# Attach AWSLambdaBasicExecutionRole policy to the Lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_logs_permissions" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
