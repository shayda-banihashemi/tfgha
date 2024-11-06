provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0709112b97e5accb1"
  instance_type = "t2.micro"

  user_data = <<-EOF
            #!/bin/bash
            yum update -y
            yum install -y python3 git

            # Clone your git repository (ensure it's public or handle git authentication accordingly)
            #cd /home/ec2-user
            #git clone https://github.com/your_username/your_repository.git

            # Navigate to the repository
            #cd your_repository

            # Optionally, create a virtual environment
            #python3 -m venv venv
            #source venv/bin/activate

            # Install any required dependencies from requirements.txt
            #pip install -r requirements.txt

            # Run your Python script
            python3 -c "import http.server; import socketserver; PORT = 8080; Handler = http.server.SimpleHTTPRequestHandler; with socketserver.TCPServer(('', PORT), Handler) as httpd: print('Serving HTTP on port', PORT); httpd.serve_forever()"
            EOF

  tags = {
    Name = "GitHubActionsEC2"
  }
}
