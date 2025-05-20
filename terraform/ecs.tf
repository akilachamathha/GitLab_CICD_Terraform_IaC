# Create the ECS cluster and service
resource "aws_ecs_cluster" "webapp" {
  name = "${local.prefix}-cluster"
}

# Create the ECS service
resource "aws_ecs_service" "webapp" {
  name            = "${local.prefix}-service"
  cluster         = aws_ecs_cluster.webapp.id
  task_definition = aws_ecs_task_definition.webapp.arn
  force_new_deployment = true   # Force a new deployment to pick up changes and new image
  launch_type     = "FARGATE"   # Use Fargate as the capacity provider
  desired_count   = 1           # Run one instance of the service

  network_configuration {
    subnets          = aws_subnet.public[*].id            # Use public subnets for internet access
    assign_public_ip = true                               # Assign public IP address to the task
    security_groups  = [aws_security_group.webapp_sg.id]  # Use the security group for the web application
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn     # Target group for the ALB
    container_name   = "${local.prefix}-container"
    container_port   = 8501                               # Port on which the container exposes for streamlit web application 
  }

  depends_on = [aws_lb_listener.http]                    
}
