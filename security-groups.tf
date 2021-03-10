resource "aws_security_group" "website-sg" {
  provider    = aws.region-nginx
  name        = "nginx-sg"
  description = "Allow TCP/80 & TCP/22 to my public IP"
  vpc_id      = var.vpc-id
  ingress {
    description = "allow my public IP on port 80"
    from_port   = var.webserver-port
    to_port     = var.webserver-port
    protocol    = "tcp"
    cidr_blocks = [var.my_pub_ip]
  }
  ingress {
    description = "allow SSH from my public IP on port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_pub_ip, var.automation_pub_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
