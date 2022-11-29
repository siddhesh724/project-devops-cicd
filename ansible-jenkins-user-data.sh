#!/bin/bash
# this is for ansible and jenkins
sudo yum update -y
sudo yum install wget -y
sudo amazon-linux-extras install epel -y
sudo amazon-linux-extras install ansible2 -y
sudo yum install python3 -y
sleep 10
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sleep 10
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade -y
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install jenkins -y
sudo yum install git tree -y
sudo yum install java-devel -y
sudo yum install fontconfig -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins