output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.this[*].id
}

output "private_ips" {
  description = "Private IP addresses of the EC2 instances"
  value       = aws_instance.this[*].private_ip
}

output "public_ips" {
  description = "Public IP addresses of the EC2 instances (if in public subnet)"
  value       = aws_instance.this[*].public_ip
}

output "security_group_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.ec2.id
}

output "iam_role_arn" {
  description = "ARN of the EC2 IAM role"
  value       = aws_iam_role.ec2.arn
}

output "instance_profile_name" {
  description = "Name of the IAM instance profile"
  value       = aws_iam_instance_profile.this.name
}
