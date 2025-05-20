# Create AWS Security Group for the web application
resource "aws_security_group" "webapp_sg" {
  name   = "${local.prefix}-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 8501  # Port for Streamlit app
    to_port     = 8501
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}