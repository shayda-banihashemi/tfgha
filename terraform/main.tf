provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "py_server" {
  ami           = "ami-0709112b97e5accb1"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_app.id]

  user_data = <<-EOF
              #!/bin/bash
              exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

              # Update system
              yum update -y
              yum install -y python3 python3-pip git curl

              # Install system dependencies
              yum install -y python3-devel gcc

              # Create app user
              useradd -m -s /bin/bash appuser

              # Set up application directory
              mkdir -p /app
              chown appuser:appuser /app

              # Switch to app user
              su - appuser << 'EOSU'
              # Set up Python environment
              python3 -m pip install --user poetry
              export PATH="$HOME/.local/bin:$PATH"

              # Clone and set up application
              cd /app
              git clone https://github.com/proquickly/tfgha.git
              cd tfgha

              # Install dependencies
              $HOME/.local/bin/poetry install
              $HOME/.local/bin/poetry lock

              # Create systemd service file
              sudo tee /etc/systemd/system/flask-app.service << 'EOF2'
              [Unit]
              Description=Flask Application
              After=network.target

              [Service]
              User=appuser
              WorkingDirectory=/app/tfgha
              Environment="PATH=/home/appuser/.local/bin:/usr/local/bin:/usr/bin:/bin"
              ExecStart=/home/appuser/.local/bin/poetry run flask run --host=0.0.0.0 --port=5000
              Restart=always

              [Install]
              WantedBy=multi-user.target
              EOF2
              EOSU

              # Set proper permissions
              chmod 644 /etc/systemd/system/flask-app.service

              # Start and enable the service
              systemctl daemon-reload
              systemctl start flask-app
              systemctl enable flask-app

              # Add logging
              echo "Setup completed at $(date)" >> /var/log/user-data.log
              EOF

  tags = {
    Name = "GitHubActionsEC2"
  }

  # Add root volume configuration if needed
  root_block_device {
    volume_size = 20
    volume_type = "gp2"
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

  tags = {
    Name = "allow_app"
  }
}

output "public_ip" {
  value = aws_instance.py_server.public_ip
}
