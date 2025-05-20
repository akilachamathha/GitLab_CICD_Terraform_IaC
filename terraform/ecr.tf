# Create a ECR repo for store the webapp image 
# This ECR repo used to store the webapp image that built via Gitlab pipeline
resource "aws_ecr_repository" "webapp-ecr" {
  name = "${local.prefix}-ecr"

  image_scanning_configuration {
    scan_on_push = true
  }
}