# to create s3 bucket
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = "my-s3-bucket"
  acl    = "private"
  versioning = {
    enabled = true
  }
}

# To create ec2 instance
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name  = "${var.stage}-ec2"
  count = var.ec2-count

  instance_type          = "t2.micro"
  ami                    = var.ec2_instance_ami
  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = "subnet-eddcdzz4" #module.vpc.private_subnets
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# To create and map EIP with ec2
resource "aws_eip" "example" {
  #count = var.instance_count
  count = var.eip-count
  vpc   = true

  tags = {
    Name = "example-eip"
  }
}

resource "aws_eip_association" "example" {
  count         = var.eip-count
  instance_id   = module.ec2_instance[count.index].id
  allocation_id = aws_eip.example[count.index].id
}

# To create ASG and map EBS to ec2
module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  name   = var.asg_name
  create = var.create_asg

  # Launch configuration
  #launch_template = module.ec2_instance.launch_template.name
  launch_template_name        = var.launch_template_name
  create_launch_template      = var.create_asg
  image_id                    = var.ec2_instance_ami
  instance_type               = var.ec2_instance_type
  instance_name               = var.ec2_instance_name
  security_groups             = [var.ec2_sg]
  iam_role_name               = "example-role"
  create_iam_instance_profile = var.create_asg
  enable_monitoring           = var.create_asg
  #key_name                   = var.key_name
  #iam_instance_profile_arn   = aws_iam_instance_profile.ec2-instance.arn
  #user_data_base64           = base64encode(local.user_data)



  # Auto scaling group
  vpc_zone_identifier       = [var.public_subnet_ids]
  health_check_type         = "EC2"
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  wait_for_capacity_timeout = 0


  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 20
        volume_type           = "gp2"
      }
      }, {
      device_name = "/dev/sda1"
      no_device   = 1
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 30
        volume_type           = "gp2"
      }
    }
  ]

  scaling_policies = {
    my-policy = {
      policy_type = "TargetTrackingScaling"
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
          resource_label         = "MyLabel"
        }
        target_value = 50.0
      }
    }
  }

  tags = {
    Environment = "dev"
    Project     = "megasecret"
  }
}
