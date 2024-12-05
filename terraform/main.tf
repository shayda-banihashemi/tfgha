provider "aws" {
  region = "us-west-2"
}

 resource "aws_key_pair" "deployer" {
   key_name   = "deployer-key" # Set this to any descriptive name you prefer
   public_key = file("id_rsa.pub")  # Path to your public key file
 }

   resource "aws_security_group" "allow_ssh" {
     name        = "allow_ssh"
     description = "Allow SSH inbound traffic"

     ingress {
       from_port   = 22
       to_port     = 22
       protocol    = "tcp"
       cidr_blocks = ["0.0.0.0/0"]  # Be cautious with this setting; restrict to specific IPs if possible
     }

     egress {
       from_port   = 0
       to_port     = 0
       protocol    = "-1"
       cidr_blocks = ["0.0.0.0/0"]
     }
   }

resource "aws_instance" "py_server" {
  ami           = "ami-06946f6c9b153d494"
  instance_type = "t2.micro"
  key_name = aws_key_pair.deployer.key_name
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y python3 python3-pip git curl
              python3 -m venv /home/ubuntu/sys
              python3 -m pip install -U poetry

              cd /home/ubuntu
              git clone https://github.com/proquickly/tfgha.git
              cd /home/ubuntu/tfgha

              /usr/local/bin/poetry lock
              /usr/local/bin/poetry install
              cd /home/ubuntu/tfgha/src/tfgha

              nohup poetry run python app.py &
              EOF

  tags = {
    Name = "FlaskAppInstance"
  }

  vpc_security_group_ids = [aws_security_group.allow_http.id,
    aws_security_group.allow_ssh.id]
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http_flask_web_app"
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
}
