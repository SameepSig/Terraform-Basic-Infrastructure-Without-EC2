output "vpc_id" {
    description = "The ID of the VPC"
    value       = aws_vpc.sameep_terraform_vpc.id  
}

output "subnet_id" {
    description = "The ID of the subnet"
    value       = aws_subnet.sameep_terraform_subnet_1.id
}

output "security_group_id" {
    description = "The ID of the security group"
    value       = aws_security_group.sameep_sg.id  
}

output "aws_iam_instance_profile" {
    description = "The IAM instance profile"
    value       = aws_iam_instance_profile.sameep_ssm_iam_role_instance_profile.name  
}