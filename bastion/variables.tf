variable "vpc_id" {
  default = ""
}

variable "public_subnet_id" {
  default = ""
}

variable "ami_id" {
  # default = "ami-01e783664013d8e8a"
  default = "" # amzn-ami-hvm-2018.08
}

variable "instance_type" {
  default = "t3.micro"
}

variable "region" {
  default = "ap-northeast-2"
}

variable "name" {
  type = string
  # default = "dev-k8s-scdf-bastion"
}

variable "administrator" {
  default = true
}

variable "allow_ip_address" {
  type = list(string)
  default = [
    "218.209.145.162/32",
    "10.205.0.0/16",
    # "121.135.87.93/32", # echo "$(curl -sL icanhazip.com)/32"
  ]
}

variable "key_name" {
  type = string
  # default = "k8s-scdf-keypair"
}

