data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_security_group" "web_sg" {
  name = "terraform-web-sg"
  description = "Allow HTTP traffic to web server"
  vpc_id = var.vpc_id
  tags = { Name = "terraform-web-sg" }
}
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web_sg.id
  referenced_security_group_id = var.alb_security_group_id
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}
resource "aws_vpc_security_group_egress_rule" "outbound" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}
resource "aws_instance" "web_server" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id = var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  user_data = <<-EOF
    #!/bin/bash
    dnf install -y nginx
    systemctl enable nginx
    systemctl start nginx

    echo "<h1>Hello from Terraform!</h1>" > /usr/share/nginx/html/index.html
  EOF
  tags = { Name = "terraform-nginx-webserver" }
  lifecycle { ignore_changes = [ami] }
}
resource "aws_instance" "web_server_2" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id = var.subnet_ids[1]
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  user_data = <<-EOF
    #!/bin/bash
    dnf install -y nginx
    systemctl enable nginx
    systemctl start nginx

    echo "<h1>Hello from Web Server 2!</h1>" > /usr/share/nginx/html/index.html
  EOF
  tags = { Name = "terraform-nginx-webserver-2" }
  lifecycle { ignore_changes = [ami] }
}
