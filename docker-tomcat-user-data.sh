#!/bin/bash
yum update -y
yum install wget -y
amazon-linux-extras install docker -y
service docker start
systemctl enable docker
usermod -a -G docker ec2-user
sleep 10
# tomcat install 
hostnamectl set-hostname tomcat.example.com
yum install java-devel -y
cd /opt/
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.35/bin/apache-tomcat-9.0.35.tar.gz
tar -zvxf apache-tomcat-9.0.35.tar.gz
cd /opt/apache-tomcat-9.0.35/bin/
chmod +x /opt/apache-tomcat-9.0.35/bin/startup.sh
chmod +x /opt/apache-tomcat-9.0.35/bin/shutdown.sh
ln -s /opt/apache-tomcat-9.0.35/bin/startup.sh /usr/bin/tomcatup
ln -s /opt/apache-tomcat-9.0.35/bin/shutdown.sh /usr/bin/tomcatdown
tomcatup
netstat -nltp | grep 8080