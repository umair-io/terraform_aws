### Install Terraform on Mac (using brew)
* Install brew
`/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
* Install terraform
`brew install terraform`

### Create AWS access key for CLI access
.....
* Go to AWS IAM Console and Create a User
`https://console.aws.amazon.com/iam/home?region=eu-west-2#/users`
* Type username and select 'Programmatic access'
* Give user 'AdministratorAccess' from the existing polcies.
* Keep clicking next and on the last page click 'Create user'
* Download .csv file. We will need it to allow terraform to access our AWS account.


### Upload your SSH public key to AWS
* `cp ~/.ssh/id_rsa.pub ~/`
* Go to console, upload key and give it a name: https://eu-west-2.console.aws.amazon.com/ec2/v2/home?region=eu-west-2#KeyPairs:sort=keyName
SS

### Create an AWS ec2 instance every terraform
* `git clone http://github.com/umair-io/terraform-aws.git`
* `cd terraform-aws`
* Install AWS terrform plugin
  `terraform init`
* Run Terraform plan to see what resources will be built
  `terraform plan`
* Modify vartiables.tf file and replace `default` for aws_access_key and aws_secret_key. Both can be found in the downloaded csv file.
* Run Terraform apply to build the resources
  `terraform apply`