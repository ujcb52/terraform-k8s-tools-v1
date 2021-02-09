terraform {
  required_version = ">= 0.12.0"
}

# resource "aws_security_group" "worker_group_mgmt_one" {
#   name_prefix = "worker_group_mgmt_one"
#   vpc_id      = var.vpc_id

#   ingress {
#     from_port = 22
#     to_port   = 22
#     protocol  = "tcp"

#     cidr_blocks = [
#       "10.192.138.0/24",     # bastion
#       "10.205.0.0/16",       # Office
#       "218.209.145.162/32"   # home
#     ]
#   }
# }

# resource "aws_security_group" "worker_group_mgmt_two" {
#   name_prefix = "worker_group_mgmt_two"
#   vpc_id      = var.vpc_id

#   ingress {
#     from_port = 22
#     to_port   = 22
#     protocol  = "tcp"

#     cidr_blocks = [
#       "10.192.138.0/24",     # bastion
#       "10.205.0.0/16",       # Office
#       "218.209.145.162/32"   # home
#     ]
#   }
# }

resource "aws_security_group" "all_worker_mgmt" {
  name = "${var.cluster_name}-all_worker_management"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.192.138.0/24",     # bastion
      "100.64.130.0/23",   # k8s-tool-bastion
      "10.205.0.0/16",       # Office
      "218.209.145.162/32"   # home
    ]
  }
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnets         = var.subnets

  tags = var.tags

  vpc_id = var.vpc_id


  ### ec2-instance-selector install
  # curl -Lo ec2-instance-selector https://github.com/aws/amazon-ec2-instance-selector/releases/download/v1.3.0/ec2-instance-selector-`uname | tr '[:upper:]' '[:lower:]'`-amd64 && chmod +x ec2-instance-selector
  # sudo mv ec2-instance-selector /usr/local/bin/
  # ec2-instance-selector --version

  ### finding cluster-autoscaler instance list
  # ec2-instance-selector --vcpus 4 --memory 16384 --gpus 0 --current-generation -a x86_64 --deny-list '.*n.*'

  worker_groups_launch_template = [
    {
      name                 = "${var.cluster_name}-system"
      # instance_type        = "m5.large"
      # override_instance_types = ["m5.large", "m5a.large", "m5d.large", "m5ad.large"]
      instance_type        = "t3.micro"
      override_instance_types = ["t3.micro"]
      spot_instance_pools     = 2
      on_demand_base_capacity = 1
      on_demand_percentage_above_base_capacity = 0
      asg_max_size            = 5
      asg_min_size            = 1
      asg_desired_capacity    = 1
      kubelet_extra_args   = "--node-labels=node.kubernetes.io/lifecycle=mixed,node.type=system"
      public_ip            = false
      key_name              = "k8s-jtool-v1"
    },
    {
      name                    = "${var.cluster_name}-mixed-1"
      # override_instance_types = ["c5.large", "m5.large", "m5a.large", "m5d.large", "m5ad.large"]
      override_instance_types = ["t3.micro"]
      spot_instance_pools     = 2
      on_demand_base_capacity = 0
      on_demand_percentage_above_base_capacity = 0
      asg_max_size            = 5
      asg_min_size            = 1
      asg_desired_capacity    = 1
      kubelet_extra_args      = "--node-labels=node.kubernetes.io/lifecycle=mixed,node.type=service"
      public_ip               = false
      key_name              = "k8s-jtool-v1"
    },
    {
      name                    = "${var.cluster_name}-2xlarge"
      # override_instance_types = ["c5.2xlarge", "m5.2xlarge"]
      override_instance_types = ["t3.micro"]      
      spot_instance_pools     = 2
      on_demand_base_capacity = 0
      on_demand_percentage_above_base_capacity = 50
      asg_max_size            = 5
      asg_min_size            = 1
      asg_desired_capacity    = 1
      kubelet_extra_args      = "--node-labels=node.kubernetes.io/lifecycle=mixed,node.type=big"
      public_ip               = false
      key_name              = "k8s-jtool-v1"
    },
  ]

  worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  map_roles                            = var.map_roles
  map_users                            = var.map_users
  map_accounts                         = var.map_accounts

  # cluster_iam_role_name = "clusterrole"

  workers_additional_policies = [

  ]

  adfs_role_names = var.adfs_role_names
}

locals {
  update_kubeconfig = "aws eks update-kubeconfig --name ${module.eks.name[0]} --alias ${module.eks.name[0]}"
}