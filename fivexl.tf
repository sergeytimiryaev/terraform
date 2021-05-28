provider "aws" {
  access_key = "" 
  secret_key = ""
  region     = "eu-central-1"
}

resource "aws_instance" "ubuntu" {
  ami                    = "ami-05f7491af5eef733a"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webserver.id]
  user_data              = <<EOF
#!/bin/bash
sudo su
apt-get update
apt-get install nginx -y
echo "<h1>Summer practice 2021<br> Timiryaev Sergey</h1>" > /var/www/html/index.html
systemctl enable nginx.service
EOF

  tags = {
    Name = "nginx-fivexl server"
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
