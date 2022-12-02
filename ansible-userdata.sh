#!/bin/bash
amazon-linux-extras install ansible2 -y
yum install python3 -y
yum install tree -y
hostnamectl set-hostname ansible.example.com