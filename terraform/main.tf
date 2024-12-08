provider "aws" {
  region = "us-west-2"
}

# Add random suffix to avoid conflicts
resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key-${random_id.suffix.hex}"
  public_key = file("id_rsa.pub")
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_${random_id.suffix.hex}"
  description = "Allow SSH inbound traffic"

  ingress {
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

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http_flask_${random_id.suffix.hex}"
  description = "Allow inbound HTTP traffic"

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "py_server" {
  ami           = "ami-06946f6c9b153d494"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  user_data     = <<-EOF
              #!/bin/bash
              PROJ=tfgha
              WORKDIR=/home/ubuntu
              sudo apt-get update
              sudo apt-get install -y python3 python3-pip git curl
              curl -sSL https://install.python-poetry.org | python3 -
              # python3 -m pip install -U poetry

              cd $WORKDIR
              git clone https://github.com/proquickly/$PROJ.git
              cd $WORKDIR/$PROJ
              export PATH="$HOME/.local/bin:$PATH"
              poetry install
              cd $WORKDIR/$PROJ/src/$PROJ

              nohup poetry run python app.py &
              EOF

  tags = {
    Name = "FlaskAppInstance"
  }

  vpc_security_group_ids = [
    aws_security_group.allow_http.id, aws_security_group.allow_ssh.id
  ]
}
