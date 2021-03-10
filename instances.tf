data "aws_ami" "alx" {
  provider = aws.region-web
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create Lauch Configuration with the prefix Web-
resource "aws_instance" "nginx" {
  provider                    = aws.region-nginx
  image_id                    = data.aws_ami.alx.id
  instance_type               = var.instance-type
  key_name                    = var.key_name
  security_groups             = [aws_security_group.nginx-sg.id]

connection {
  type		= "ssh"
  host		= self.public_ip
  user		= "ec2-user"
  private_key	= file (var.private_key_path)

  user_data = <<USER_DATA
#!/bin/bash
yum update -y
yum -y install httpd git
cd /tmp;git clone https://github.com/p-batey/static-website.git
mv static-website/index.html /var/www/html/
mv static-website/images /var/www/html/
mv static-website/assets /var/www/html/
mv static-website/error /var/www/html/
sudo sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf
# Harden Apache
echo "ServerSignature Off" >> /etc/httpd/conf/httpd.conf
echo "ServerTokens Prod" >> /etc/httpd/conf/httpd.conf
yum -y install mod_security
service httpd start
service httpd enable
  USER_DATA

  lifecycle {
    create_before_destroy = true
  }
}
