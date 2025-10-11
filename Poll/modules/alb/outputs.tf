output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "listener_arn" {
  value = aws_lb_listener.http.arn
}

output "alb_dns" {
  value = aws_lb.this.dns_name
}

output "grafana_tg_arn" {
  value = aws_lb_target_group.grafana.arn
}

# output "alb_arn" {
#   value = aws_lb.this.arn
# }
