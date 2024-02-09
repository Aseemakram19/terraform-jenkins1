terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

# create security group for the ec2 instance
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2 security group"
  description = "allow access on ports 8080 and 22"

  # allow access on port 8080
  ingress {
    description = "http proxy access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow access on port 22
  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins server security group"
  }
}

resource "aws_instance" "Jenkins_server" {
ami = "ami-03f4878755434977f"  
instance_type = "t2.micro"
security_groups = [aws_security_group.ec2_security_group.name]
key_name = var.key_name
tags = {
  Name: var.instance_name
}
 connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("${path.module}/${var.private_key}")
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y", #Updates the package list on the target machine.
      "sleep 5", #Pauses execution for 5 seconds. This is often used to allow previous commands to complete before moving on to the next one.
      "sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key",
      "echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
       #Downloads the Jenkins GPG key and saves it as a keyring file, Adds the Jenkins repository to the package manager's sources list.
      "sudo apt-get update", #Updates the package list on the target machine.
      "sudo apt-get install fontconfig openjdk-17-jre -y", #JAVA OPENJDK INSTALLATION
      "sleep 5", #Pauses execution for 5 seconds. This is often used to allow previous commands to complete before moving on to the next one.
      "sudo apt-get install jenkins -y", #INSTALL JENKINS
      "sudo systemctl enable jenkins", #enable the Jenkins service to start at boot
      "sudo systemctl start jenkins",   ###start the Jenkins service with the command 
      "sleep 5", #Pauses execution for 5 seconds. This is often used to allow previous commands to complete before moving on to the next one.
      "sudo echo 'The initial admin password is: '; cat /var/lib/jenkins/secrets/initialAdminPassword" # Prints a message and then displays the content of the Jenkins initial admin password file.
    ]
  }
}
