provider "aws" {
	region = "us-east-1"
}


resource "aws_instance" "jenkins" {
  ami             = "ami-09d3b3274b6c5d4aa"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.jenkins-sg.name]
  key_name        = "jenkins-key"
    provisioner "remote-exec" {
    inline = [
	  "sudo yum update –y",
	  "sudo wget -O /etc/yum.repos.d/jenkins.repo  https://pkg.jenkins.io/redhat-stable/jenkins.repo",
      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
	  "sudo yum upgrade -y",
      "sudo amazon-linux-extras install java-openjdk11 -y",
      "sudo yum install jenkins -y",
      "sudo systemctl enable jenkins",
	  "sudo systemctl start jenkins",
	  "sudo systemctl status jenkins",
    ]
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("C:\\DevOps\\Jenkins_terraform\\jenkins-key.pem")
  }
  tags = {
    "Name" = "Jenkins"
  }
}