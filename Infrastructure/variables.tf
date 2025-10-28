variable "instance_name" {
  type = string
  default = "magento2-server"
}

variable "key_pair" {
    type = string
    default = "devops"  
}

variable "ami" {
  description = "This is the ami of debian 12 (debian-12-amd64-20240702-1796)"
  default = "ami-00402f0bdf4996822"
}

variable "instance_type" {
    description = "Bare minimum configuration for deploying magento-2 with cost effectiveness"
    default = "t3.medium"
}

variable "root_volume_size" {
    description = "Adding extra volume to run the application smoothly"
    default = 45
}

variable "ingress_rules" {
    description = "Allow inbound traffic from HTTP HTTPS SSH"
    type = list(object({
      port = number
      protocol = string
      cidr_block = list(string)
    }))
    default = [
        {
            port = 22
            protocol = "tcp"
            cidr_block = ["0.0.0.0/0"]
        },
        {
            port = 80
            protocol = "tcp"
            cidr_block = ["0.0.0.0/0"]
        },
        {
            port = 443
            protocol = "tcp"
            cidr_block = ["0.0.0.0/0"]
        }
    ]
}