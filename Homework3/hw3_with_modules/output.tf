output "application_load_balancer_dns" {
    value = module.ec2.application_load_balancer_dns
}

output "web_servers_public_ip" {
    value = module.ec2.web_servers_public_ip
}

output "web_servers_private_ip" {
    value = module.ec2.web_servers_private_ip
}

output "db_servers_private_ip" {
    value = module.ec2.db_servers_private_ip
}

