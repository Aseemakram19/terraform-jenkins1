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
  region = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "Jenkins_server" {
ami = "ami-0c7217cdde317cfec"  
instance_type = "t2.micro"
security_groups = [ "default" ]
key_name = var.key_name
tags = {
  Name: var.instance_name
}
 connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file(var.private_key)
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
      "sleep 5",#Pauses execution for 5 seconds. This is often used to allow previous commands to complete before moving on to the next one.
      "sudo echo 'The initial admin password is: '; cat /var/lib/jenkins/secrets/initialAdminPassword" # Prints a message and then displays the content of the Jenkins initial admin password file.
    ]
  }
}
