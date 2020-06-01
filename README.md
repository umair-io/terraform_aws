### Install Terraform on Mac (using brew)
* Install [Homebrew][homebrew]:

  `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

* Install terraform:

  `brew install terraform`

[homebrew]: https://brew.sh

### Create AWS access key for CLI access
* Go to AWS IAM Console and Create a User: [AWS IAM Users]
* Type username and select 'Programmatic access'
* Give user 'AdministratorAccess' from the existing polcies.
* Keep clicking next and on the last page click 'Create user'
* Download .csv file. We will need it to allow terraform to access our AWS account.

[AWS IAM Users]: https://console.aws.amazon.com/iam/home?region=eu-west-2#/users

### Create an Webserver on AWS EC2 instance using Terraform

* Pull the project from github:

  ```sh
  git clone git@github.ibm.com:Umair-Khan2/terraform_aws.git
  cd terraform-aws
  ```

* Modify `variables.tf` file with your deployment region

* Setup environment variables with your AWS access key and secret:

  ```sh
  export AWS_ACCESS_KEY_ID=<your access key>
  export AWS_SECRET_ACCESS_KEY=<your secret>
  ```
  Both can be found in the downloaded csv file. Additional info can be found [here][awsenv]
  
  [awsenv]: https://www.terraform.io/docs/providers/aws/index.html#environment-variables
  
* Install AWS terrform plugin:

  ```sh
  terraform init
  ```
  
* Run Terraform plan to see what resources will be built:
  ```sh
  terraform plan
  ```
  
* Run Terraform apply to build the resources:

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


