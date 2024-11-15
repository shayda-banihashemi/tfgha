provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "py_server" {
  ami           = "ami-0709112b97e5accb1"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_app.id]
  user_data = <<-EOF
            #!/bin/bash
            yum update -y
            yum install -y python3 python3-pip git curl
            curl -sSL https://install.python-poetry.org | python3 -
            export PATH="\$HOME/.local/bin:\$PATH"
            mkdir /app
            cd /app && git clone https://github.com/proquickly/tfgha.git
            chmod +x /app/tfgha/bin/deploy
            cd /app/tfgha && \$HOME/.local/bin/poetry install
            cd /app/tfgha && \$HOME/.local/bin/poetry run /app/tfgha/src/tfgha/app.py
  EOF
  tags = {
    Name = "GitHubActionsEC2"
  }
}

resource "aws_security_group" "allow_app" {
  name        = "allow_app"
  description = "Allow inbound traffic for Python app"
  ingress {
    description = "App Port"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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

output "public_ip" {
  value = aws_instance.py_server.public_ip
}
