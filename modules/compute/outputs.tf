output "instance_ids" { value = [aws_instance.web_server.id, aws_instance.web_server_2.id] }
output "public_ips" { value = [aws_instance.web_server.public_ip, aws_instance.web_server_2.public_ip] }
