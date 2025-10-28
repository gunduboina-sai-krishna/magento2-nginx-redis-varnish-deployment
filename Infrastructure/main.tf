data "aws_vpc" "magento2_vpc" {
    default = true
}

resource "aws_security_group" "magento2_sg" {
  name = "magento2_sg"
  description = "Allow inbound traffic from HTTP HTTPS SSH"
  vpc_id = data.aws_vpc.magento2_vpc.id
   
    tags = {
      Name = "magento2-sg"
    }

   dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port = ingress.value.port
      to_port =  ingress.value.port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_block
    }
   }

   egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
   }
}

resource "aws_instance" "magento2_ec2" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_pair
    vpc_security_group_ids = [ aws_security_group.magento2_sg.id ]
    associate_public_ip_address = true

    root_block_device {
      volume_size = var.root_volume_size
      volume_type = "gp3"
      delete_on_termination = true
    }

    user_data = <<-EOF
            #!/bin/bash
            apt-get update -y
            apt-get install -y cloud-guest-utils jq
            EOF

    tags = {
      Name = var.instance_name
    }
}