provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
    source = "./module/vpc"
    vpc-config = {
        cidr_block = "10.0.0.0/16"
        name       = "my-test-vpc"
    }
    subnet-config = {
        public_subnet = {
            cidr_block = "10.0.0.0/24"
            az         = "ap-south-1a"
            public     = true
        }
        private_subnet = {
            cidr_block = "10.0.1.0/24"
            az         = "ap-south-1b"
            public     = false
        }
    }
}

module "ec2-instance" {
    source              = "./module/ec2"
    ami                 = "ami-0e35ddab05955cf57"
    instance_type       = "t2.micro"
    associate_public_ip = true
    name                = "My-ec2-instance"
    subnet_id           = module.vpc.subnet-config.public_subnet["public_subnet"]
    key_name = "linux-key"
    vpc_security_group_ids = [module.security-group.security_group_id]
    iam_instance_profile = module.my_iam.instance_profile_name
    vpc_id = module.vpc.vpc_id
    depends_on = [module.security-group]
    user_data = <<EOF
#!/bin/bash
sudo apt update
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
EOF
    # vpc_security_group_ids = [module.security-group.aws_security_group.my-sg.id]
}

module "security-group" {
    source = "./module/security"
    name   = "my-sg-12332"
    tag_name = "my-sg-12332"
    vpc_id = module.vpc.vpc_id
    depends_on = [ module.vpc ]
    ingress_rules = [
        {
            from_port = 80
            to_port = 80
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        },
        {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    ]
    egress_rules = [
         {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]

    } ]
}

module "my_iam" {
    source = "./module/IAM"
    iam_role_name = "my-iam-role"
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    instance_profile_name = "my-instance-profile"
    
}

module "s3-bucker" {
    source      = "./module/S3"
    bucket_name = "my-s3-bucket-99883"
    tags = {
        Name = "my-s3-bucket-99883"
    }
}

