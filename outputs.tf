output "vpc_id" { value = module.network.vpc_id }
output "vpc_cidr" { value = module.network.vpc_cidr }
output "web_server_public_ip" { value = module.compute.public_ips[0] }
output "web_server_2_public_ip" { value = module.compute.public_ips[1] }
output "website_url" { value = "http://${module.compute.public_ips[0]}" }
output "website_2_url" { value = "http://${module.compute.public_ips[1]}" }
output "alb_url" { value = "http://${module.alb.dns_name}" }
