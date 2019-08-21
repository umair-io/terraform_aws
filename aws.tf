provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.my_key_pair}"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    # SSH 
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # HTTP
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "webserver" {
  ami = "ami-0d8e27447ec2c8410"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.auth.id}"
  security_groups = ["allow_ssh"]
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      host = "${aws_instance.webserver.public_ip}"
      user = "ec2-user"
      port = "22"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
    inline = [
      "sudo yum -y install httpd",
      "echo '<h1>Hi HMRC DevOps</h1>' > index.html",
      "sudo cp index.html /var/www/html/index.html",
      "sudo service httpd start"
    ]
  }
  tags = {
    Name = "web-server"
  }
  depends_on = ["aws_security_group.allow_ssh"]
}

