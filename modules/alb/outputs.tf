output "security_group_id" { value = aws_security_group.alb_sg.id }
output "dns_name" { value = aws_lb.web_alb.dns_name }
output "target_group_arn_suffix" { value = aws_lb_target_group.web_tg.arn_suffix }
output "load_balancer_arn_suffix" { value = aws_lb.web_alb.arn_suffix }
