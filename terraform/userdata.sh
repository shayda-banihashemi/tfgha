#!/bin/bash
sudo apt-get update -y
sudo apt-get install python3 -y
sudo apt-get install git -y

mkdir -p /app
cp ./hello.py /app/hello.py

python3 /app/hello.py &
