# Migrate existing root-state addresses into modules. Keep until every workspace has migrated.
moved {
  from = aws_vpc.main
  to = module.network.aws_vpc.main
}
moved {
  from = aws_subnet.public_subnet_1
  to = module.network.aws_subnet.public_subnet_1
}
moved {
  from = aws_subnet.public_subnet_2
  to = module.network.aws_subnet.public_subnet_2
}
moved {
  from = aws_internet_gateway.igw
  to = module.network.aws_internet_gateway.igw
}
moved {
  from = aws_route_table.public_rt
  to = module.network.aws_route_table.public_rt
}
moved {
  from = aws_route_table_association.public_assoc
  to = module.network.aws_route_table_association.public_assoc
}
moved {
  from = aws_route_table_association.public_assoc_2
  to = module.network.aws_route_table_association.public_assoc_2
}
moved {
  from = aws_security_group.web_sg
  to = module.compute.aws_security_group.web_sg
}
moved {
  from = aws_vpc_security_group_ingress_rule.http
  to = module.compute.aws_vpc_security_group_ingress_rule.http
}
moved {
  from = aws_vpc_security_group_egress_rule.outbound
  to = module.compute.aws_vpc_security_group_egress_rule.outbound
}
moved {
  from = aws_instance.web_server
  to = module.compute.aws_instance.web_server
}
moved {
  from = aws_instance.web_server_2
  to = module.compute.aws_instance.web_server_2
}
moved {
  from = aws_security_group.alb_sg
  to = module.alb.aws_security_group.alb_sg
}
moved {
  from = aws_vpc_security_group_ingress_rule.alb_http
  to = module.alb.aws_vpc_security_group_ingress_rule.alb_http
}
moved {
  from = aws_vpc_security_group_egress_rule.alb_outbound
  to = module.alb.aws_vpc_security_group_egress_rule.alb_outbound
}
moved {
  from = aws_lb.web_alb
  to = module.alb.aws_lb.web_alb
}
moved {
  from = aws_lb_target_group.web_tg
  to = module.alb.aws_lb_target_group.web_tg
}
moved {
  from = aws_lb_target_group_attachment.server_1
  to = module.alb.aws_lb_target_group_attachment.server_1
}
moved {
  from = aws_lb_target_group_attachment.server_2
  to = module.alb.aws_lb_target_group_attachment.server_2
}
moved {
  from = aws_lb_listener.http
  to = module.alb.aws_lb_listener.http
}
