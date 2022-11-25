#!/bin/bash
sudo apt-get update -y
sudo sed -i 's/#Port 22/Port 6522/' /etc/ssh/sshd_config
sudo service ssh restart