output "public_subnet_id" {
    value = aws_subnet.public.id
}

output "private_subnet_id" {
    value = aws_subnet.public.id
}

output "public_instance_count" {
    value = local.public_instance_count
}

output "private_instance_count" {
    value = local.private_instance_count
}

output "public_subnet_count" {
    value = local.public_subnet_count
}

output "private_subnet_count" {
    value = local.private_subnet_count
}