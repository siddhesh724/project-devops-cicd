data "aws_ami" "amazonlinux2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20221103.3-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # amazon2
}
// ec2 instance for jenkins 
resource "aws_instance" "terraform-project-CICD-EC2" {
  count                  = var.ec2-count
  ami                    = data.aws_ami.amazonlinux2.id
  instance_type          = var.EC2_COMPUTE
  key_name               = aws_key_pair.deployer.key_name
  subnet_id              = aws_subnet.terraform-public-subnet[0].id
  vpc_security_group_ids = [aws_security_group.terraform-sg.id]
  user_data              = file("ansible-jenkins-user-data.sh")

  tags = {
    Name = "terraform-ci-jenkins"
  }
  connection {
    user        = var.USER
    private_key = file("spring-petclinic")
    host        = self.public_ip
  }
  /* provisioner "file" {
    source      = "ansible-jenkins-user-data.sh"
    destination = "/tmp/ansible-jenkins-user-data.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/ansible-jenkins-user-data.sh",
      "sudo /tmp/ansible-jenkins-user-data.sh"
    ]
  } */
}
//key pair
resource "aws_key_pair" "deployer" {
  key_name   = "spring-petclinic"
  public_key = file("spring-petclinic.pub")
}
// ec2 instance for docker and tomcat
resource "aws_instance" "terraform-project-web" {
  count                  = var.ec2-count
  ami                    = data.aws_ami.amazonlinux2.id
  instance_type          = var.EC2_COMPUTE
  key_name               = aws_key_pair.deployer.key_name
  subnet_id              = aws_subnet.terraform-public-subnet[1].id
  vpc_security_group_ids = [aws_security_group.terraform-sg.id]
  user_data              = file("docker-tomcat-user-data.sh")

  tags = {
    Name = "terraform-tomcat-docker"
  }
  connection {
    user        = var.USER
    private_key = file("spring-petclinic")
    host        = self.public_ip
  }
  /* provisioner "file" {
    source      = "docker-tomcat-user-data.sh"
    destination = "/tmp/docker-tomcat-user-data.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/docker-tomcat-user-data.sh",
      "sudo /tmp/docker-tomcat-user-data.sh",
      "chmod +rwx /opt/apache-tomcat-9.0.35/bin/startup.sh",
      "chmod +rwx /opt/apache-tomcat-9.0.35/bin/shutdown.sh"
    ]
  } */
}
// ec2 instance for ansible
resource "aws_instance" "terraform-project-CD-EC2" {
  count                  = var.ec2-count
  ami                    = data.aws_ami.amazonlinux2.id
  instance_type          = var.EC2_COMPUTE
  key_name               = aws_key_pair.deployer.key_name
  subnet_id              = aws_subnet.terraform-public-subnet[0].id
  vpc_security_group_ids = [aws_security_group.terraform-sg.id]
  user_data              = file("ansible-userdata.sh")

  tags = {
    Name = "terraform-cd-ansible"
  }
  connection {
    user        = var.USER
    private_key = file("spring-petclinic")
    host        = self.public_ip
  }
  /* provisioner "file" {
    source      = "ansible-jenkins-user-data.sh"
    destination = "/tmp/ansible-jenkins-user-data.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/ansible-jenkins-user-data.sh",
      "sudo /tmp/ansible-jenkins-user-data.sh"
    ]
  } */
}