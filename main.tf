provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "available" {}

# Data source to get the existing IAM role
data "aws_iam_role" "ec2_s3_full" {
  name = "EC2_S3_Access_Full"
}

# Create the IAM instance profile
resource "aws_iam_instance_profile" "ec2_s3_full_profile" {
  name = "ec2_s3_full_profile"
  role = data.aws_iam_role.ec2_s3_full.name
}

# Instance configuration
resource "aws_instance" "kafka_broker" {
  count                       = 1
  ami                         = "ami-04a81a99f5ec58529"
  instance_type               = "t2.medium"
  key_name                    = "AWS-EC2-Key"
  availability_zone           = data.aws_availability_zones.available.names[count.index]
  associate_public_ip_address = true
  user_data                   = file("userdata.sh")

  iam_instance_profile = aws_iam_instance_profile.ec2_s3_full_profile.name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "Kafka-broker-${count.index + 1}"
  }

  lifecycle {
    ignore_changes = [security_groups]
 }
}

output "instance_ips" {
    value = aws_instance.kafka_broker[*].public_ip
}
