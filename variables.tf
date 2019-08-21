# adjust these values per your deployment and account
variable "aws_access_key" {
  description = "AWS key id"
  default = "YOUR_ACCESS_KEY"
}

variable "aws_secret_key" {
  description = "AWS secret key"
  default = "YOUR_SECRET_KEY"
}

variable "aws_region" {
  description = "The AWS region to deploy into"
  default     = "eu-west-2"
}

variable "my_key_pair" {
    type = "string"
    default = "deployer-key"
}