#!/bin/bash
sudo yum update -y
sudo yum install wget -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
sleep 10
# tomcat install 
sudo hostnamectl set-hostname tomcat.example.com
sudo yum install java-devel -y
cd /opt/
sudo wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.35/bin/apache-tomcat-9.0.35.tar.gz
sudo tar -zvxf apache-tomcat-9.0.35.tar.gz
sudo su
cd
cd /opt/apache-tomcat-9.0.35/bin/
chmod +rwx /opt/apache-tomcat-9.0.35/bin/startup.sh
chmod +rwx /opt/apache-tomcat-9.0.35/bin/shutdown.sh
ln -s /opt/apache-tomcat-9.0.35/bin/startup.sh /usr/bin/tomcatup
ln -s /opt/apache-tomcat-9.0.35/bin/shutdown.sh /usr/bin/tomcatdown
tomcatup
netstat -nltp | grep 8080