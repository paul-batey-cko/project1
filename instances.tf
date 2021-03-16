data "aws_ami" "alx" {
  provider    = aws.region-nginx
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create Lauch Configuration with the prefix Web-
resource "aws_instance" "nginx" {
  provider               = aws.region-nginx
  ami                    = data.aws_ami.alx.id
  instance_type          = var.instance-type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)
  }

#  provisioner "remote-exec" {
#    inline = [
#      "sudo yum install nginx -y",
#      "sudo service nginx start"
#    ]
#  }

user_data = "${file("user-data.sh")}"

  tags = {
    Name = "NGINX-Test"
  }
}
