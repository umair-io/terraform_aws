# Creating AWS resources using Terraform

### What is Terraform?
Terraform is a Infrastructure as code (IAC) tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions. 

### How does Terraform work?
Configuration files describe to Terraform the components needed to run a single application or your entire datacenter. Terraform generates an execution plan describing what it will do to reach the desired state, and then executes it to build the described infrastructure. As the configuration changes, Terraform is able to determine what changed and create incremental execution plans which can be applied.

### Why use terraform?
Amongst other benefits, it allows use to create a blueprint of our infrastructure and then apply it as many times or in as many places as we like. Since it's IAC, it can be version controlled and hence we can view and manage or Infra changes history and revert to a point in past if needed.

### What are we going to do today?

We are going to be building our first ec2 instance, without AWS GUI console, in an automated way using terraform. We will also setup a security group (firewall) to allow for web port so we can view our web server (which we will alos provision) in the browser.

 
 Lets get started!

## The AWS Stuff

### Setup AWS account

#### Create AWS account (free-tier)
* Go to https://aws.amazon.com/free/ and follow instructions to sign up to AWS. (Debit/Credit card required)
  
#### Create AWS access key for CLI access
* Go to AWS IAM Console and Create a User. [Direct link](https://console.aws.amazon.com/iam/home?region=eu-west-2#/users)
* Type username and select 'Programmatic access'
* Give user 'AdministratorAccess' from the existing policies.
* Keep clicking next and on the last page click 'Create user'
* Download .csv file. We will need it to allow terraform to access our AWS account.

### Local AWS config
#### Set AWS credentials
* Fill in the following details (Both can be found in the downloaded csv file) and then run the following command: 

```shell
echo "[default]
aws_access_key_id = [YOUR 'Access key ID' IN DOWNLOADED CSV]
aws_secret_access_key = [YOUR 'Secret access key' IN DOWNLOADED CSV]" >~/.aws/credentials
```

This will now allow terraform to automatically pick you AWS creds from ~/.aws/credentials


  ## Terraform
  
### Install Terraform
* For Windows, follow [this guide](https://www.terraform.io/downloads.html)
* For Mac, run the following commands:
```
# Install brew
`/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

# Install terraform (using brew)
brew install terraform
```

### Creating a Webserver on AWS EC2 instance using Terraform

#### Creating variables file
We'll start by creating the variables file. This will contain dynamic variables which will be used by the terraform template file. Create a file **variables.tf** and fill it with the following contents (feel free to replace eu-west-2 with your preferred region):

```json
variable "aws_region" {
  description = "The AWS region to deploy into"
  default     = "eu-west-2"
}

variable "my_key_pair" {
    type = "string"
    default = "deployer-key"
}
```

#### Creating terraform.tf file
Now it's to create a terraform.tf file which will define what our infrastructure will contain.  Create a file **terraform.tf** and fill it with the following contents:
```json
provider "aws" {
    region = "${var.aws_region}"
}

#Ensure that your ssh public access key exists under ~/.ssh/id_rsa.pub
resource "aws_key_pair" "auth" {
  key_name   = "${var.my_key_pair}"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

data "aws_ami" "amazon-linux-2" {
 most_recent = true
 owners = ["amazon"]
 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
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
    # All ports
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "webserver" {
  ami = "${data.aws_ami.amazon-linux-2.id}"
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
      "echo '<h1>Hi DevOps</h1>' > index.html",
      "sudo cp index.html /var/www/html/index.html",
      "sudo service httpd start"
    ]
  }
  tags = {
    Name = "web-server"
  }
  depends_on = ["aws_security_group.allow_ssh"]
}
```

  
Since we are using building AWS resource using terraform, let's install AWS terrform plugin:

```sh
terraform init
```
  
Now let's run run Terraform plan to see what resources will be built:
```sh
terraform plan
```
  
And finally run Terraform apply to build the resources:

```sh
terraform apply
```
  
### Destroy the AWS EC2 instance using Terraform

It's is always good practice to clean-up after use, so here we go:

```sh
terraform destroy
```

> Note: Be mindfull about the `terraform.tfstate` file! If you loose it, you can not destroy!
=======


