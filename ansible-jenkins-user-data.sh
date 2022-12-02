#!/bin/bash
# this is for ansible and jenkins
yum update -y
yum install wget -y
amazon-linux-extras install epel -y
# amazon-linux-extras install ansible2 -y
yum install python3 -y
sleep 10
wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sleep 10
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum upgrade -y
amazon-linux-extras install java-openjdk11 -y
yum install jenkins -y
yum install git tree -y
yum install java-devel -y
yum install fontconfig -y
systemctl enable jenkins
systemctl start jenkins
systemctl status jenkins