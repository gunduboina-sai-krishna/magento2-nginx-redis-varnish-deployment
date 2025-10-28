output "magento2_sg_id" {
  value = aws_security_group.magento2_sg.id
}

output "instance_id" {
  value = aws_instance.magento2_ec2.id
}