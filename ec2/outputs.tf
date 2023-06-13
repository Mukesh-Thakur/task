output "ec2_instance_id" {
  description = "The ID of the instance"
  value       = module.ec2_instance[0].id
}

output "ec2_instance_arn" {
  description = "The ARN of the instance"
  value       = module.ec2_instance[0].arn
}

output "eip_id" {
  value = aws_eip.example[0].id
}
