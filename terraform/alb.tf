# Create an Application Load Balancer (ALB) for the web application
resource "aws_lb" "alb" {
  name               = "${local.prefix}-alb"
  internal           = false     # False for internal ALB   
  load_balancer_type = "application" # LB type as Application Load Balancer
  subnets            = aws_subnet.public[*].id
  security_groups    = [aws_security_group.webapp_sg.id]
}

# Create a target group for the ECS service
resource "aws_lb_target_group" "ecs_tg" {
  name        = "${local.prefix}-ecs-tg"
  port        = 8501    # Port for the streamlit web application
  protocol    = "HTTP"  
  target_type = "ip"
  vpc_id      = aws_vpc.main.id
  health_check {         # Health check configuration
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# Create a listener for the ALB
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 8501
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}