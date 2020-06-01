# adjust these values per your deployment
#
# Do not insert your AWS keys here since that would easily leads to exposure
# of your AWS access credentials when (accidentially) committing this file
# into your repo. Those that have read access to the repo are then able to
# alter the infrastructure.
#
variable "aws_region" {
  description = "The AWS region to deploy into"
  default     = "eu-west-2"
}

variable "my_key_pair" {
    type = "string"
    default = "deployer-key"
}
