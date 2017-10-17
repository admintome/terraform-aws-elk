output "kibana_url" {
  value = "http://${aws_eip.ip.public_ip}:5601"
}
