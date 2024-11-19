provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "py_server" {
  ami           = "ami-06946f6c9b153d494"
  instance_type = "t2.micro"

user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y python3 python3-pip

              # Install Flask
              pip3 install flask

              # Create application directory
              mkdir -p /home/ubuntu/app

              # Write the Python script to a file
              cat <<EOL > /home/ubuntu/app/app.py
              from flask import Flask

              app = Flask(__name__)

              @app.route('/')
              def hello():
                  return "Hello from Python!"

              app.run(host='0.0.0.0', port=5000)
              EOL

              # Change to the application directory and run the app
              cd /home/ubuntu/app
              python3 app.py &
              EOF

  tags = {
    Name = "FlaskAppInstance"
  }

  # Define a security group to allow HTTP traffic
  vpc_security_group_ids = [aws_security_group.allow_http.id]
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
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
