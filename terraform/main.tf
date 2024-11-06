provider "aws" {
  region = "us-west-2"  # Specify your desired region
}

resource "aws_instance" "example" {
  ami           = "ami-0709112b97e5accb1"  # Amazon Linux 2 AMI (change as needed)
  instance_type = "t2.micro"

  tags = {
    Name = "GitHubActionsEC2"
  }
}
