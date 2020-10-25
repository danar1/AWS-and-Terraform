output "application_load_balancer_dns" {
    value = module.alb.this_lb_dns_name
}

output "web_servers_public_ip" {
    value = module.web.public_ip
}

output "web_servers_private_ip" {
    value = module.web.private_ip
}

output "db_servers_private_ip" {
    value = module.db.private_ip
}
