provider "aws" {
  #access_key = ""
  #secret_key = ""
  region = "eu-central-1"
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.ubuntu.id
}

data "aws_ami" "ubuntu" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ubuntu" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webserver.id]
  user_data              = <<EOF
#!/bin/bash
sudo su
apt-get update
apt-get install nginx -y
echo "<h1>Timiryaev Sergey</h1> <br> <h2>aws web-server</h2>" > /var/www/html/index.html
systemctl enable nginx.service
EOF

  tags = {
    Name = "nginx-fivexl server"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "webserver" {
  name = "webserver security group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webserver"
  }
}
