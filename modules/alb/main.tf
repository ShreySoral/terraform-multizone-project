resource "aws_security_group" "alb_sg" {
  name = "terraform-alb-sg"
  description = "Security group for application load balancer"
  vpc_id = var.vpc_id
  tags = { Name = "terraform-alb-sg" }
}
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}
resource "aws_vpc_security_group_egress_rule" "alb_outbound" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}
resource "aws_lb" "web_alb" {
  name = "terraform-web-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets = var.subnet_ids
  tags = { Name = "terraform-web-alb" }
}
resource "aws_lb_target_group" "web_tg" {
  name = "terraform-web-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check {
    path = "/"
    protocol = "HTTP"
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 30
    timeout = 5
  }
  tags = { Name = "terraform-web-tg" }
}
resource "aws_lb_target_group_attachment" "server_1" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id = var.instance_ids[0]
  port = 80
}
resource "aws_lb_target_group_attachment" "server_2" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id = var.instance_ids[1]
  port = 80
}
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}
