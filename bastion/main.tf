terraform {
  backend "s3" {
    region         = "ap-northeast-2"
    bucket         = "terraform-k8s-tool-state"
    key            = "bastion-v1.tfstate"
  }
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.region
}

module "bastion" {
  # source = "github.com/11stcorp/terraform-aws-bastion?ref=v0.0.2"
  source = "./modules/terraform-aws-bastion"

  name = var.name

  vpc_id = var.vpc_id
  subnet_id = var.public_subnet_id
  ami_id = var.ami_id
  instance_type = var.instance_type

  administrator = var.administrator

  allow_ip_address = var.allow_ip_address

  user_data = data.template_file.setup.rendered

  key_name = var.key_name
}