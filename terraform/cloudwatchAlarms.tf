# Cloudwatch Alarms for ECS CPU usage > 80%
# This alarm is used to trigger lambda and scale up the ECS service capacity provider
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "webapp-ecs-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 80    # CPU usage threshold 80%
  evaluation_periods  = 2     # Number of periods to evaluate
  period              = 60    # Period in seconds (1min)
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  statistic           = "Average"

  dimensions = {
    ClusterName = aws_ecs_cluster.webapp.name
    ServiceName = aws_ecs_service.webapp.name
  }

  alarm_description   = "Scale Up when CPU > 80%"
  alarm_actions = [aws_lambda_function.ecs_vertical_scaler_up.arn] # Trigger the scale up lambda function
}

# Cloudwatch Alarms for ECS CPU usage < 20%
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "webapp-ecs-cpu-low"
  comparison_operator = "LessThanThreshold"
  threshold           = 20    # CPU usage threshold 20%
  evaluation_periods  = 6     # Number of periods to evaluate
  datapoints_to_alarm = 5     # Number of data points to alarm
  period              = 300   # Period in seconds (5min)
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  statistic           = "Average"

  dimensions = {
    ClusterName = aws_ecs_cluster.webapp.name
    ServiceName = aws_ecs_service.webapp.name
  }

  treat_missing_data = "notBreaching" # treat missing data as not breaching
}

# Cloudwatch Alarms for ECS has traffic. Its monitor the ALB target group
resource "aws_cloudwatch_metric_alarm" "has_traffic" {
  alarm_name          = "webapp-ecs-has-traffic"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 1     # Request count threshold
  evaluation_periods  = 1     # Number of periods to evaluate
  period              = 300   # Period in seconds (5min)
  metric_name         = "RequestCountPerTarget"
  namespace           = "AWS/ApplicationELB"
  statistic           = "Sum"

  dimensions = {
    TargetGroup = aws_lb_target_group.ecs_tg.arn_suffix
  }

  treat_missing_data = "notBreaching" # treat missing data as not breaching
}

# Cloudwatch Alarms for ECS CPU usage < 20% AND has traffic. This ensures that the scale down alarm is triggered only when there is traffic and CPU is low
# This alarm is used to trigger lambda and scale down the ECS service capacity provider
resource "aws_cloudwatch_composite_alarm" "scale_down" {
  alarm_name = "webapp-ecs-vertical-scale-down"
  alarm_rule = join(
    " AND ",      # check both alarms are in ALARM state
    [
      "ALARM(${aws_cloudwatch_metric_alarm.cpu_low.alarm_name})",
      "ALARM(${aws_cloudwatch_metric_alarm.has_traffic.alarm_name})",
    ]
  )

  alarm_description = "Scale down only when CPU <20% AND there has been traffic in the last 5min"
  alarm_actions     = [ aws_lambda_function.ecs_vertical_scaler_down.arn ]  # Trigger the scale down lambda function

}
