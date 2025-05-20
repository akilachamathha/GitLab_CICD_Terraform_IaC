# Create aws ecs task definition for the web application in ECS

resource "aws_ecs_task_definition" "webapp" {
  family                   = "${local.prefix}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.cpu}"
  memory                   = "${var.memory}"
  
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn  # IAM role for ECS task execution

  container_definitions = jsonencode([
    {
      name      = "${local.prefix}-container" 
      image     =  "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-west-2.amazonaws.com/dev-webapp-ecr:webapp-1.0"  # Docker image for the web application. This is the ECR image URL.
      essential = true
      portMappings = [
        {
          containerPort = 8501    # Port for Streamlit app
          hostPort      = 8501
        }
      ]
      logConfiguration = {        # Cloudwatch Log configuration for the ECS container
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${local.prefix}"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}