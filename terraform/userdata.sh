#!/bin/bash
sudo yum update -y
sudo yum install python3 -y
sudo yum install git -y

mkdir -p /app
cp ./hello.py /app/hello.py

python3 /app/hello.py &
