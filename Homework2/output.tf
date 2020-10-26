output "application_load_balancer_dns" {
    value = aws_lb.alb.dns_name
}

output "web_servers_public_ip" {
    value = aws_instance.web.*.public_ip
}

output "web_servers_private_ip" {
    value = aws_instance.web.*.private_ip
}

output "db_servers_private_ip" {
    value = aws_instance.db.*.private_ip
}

