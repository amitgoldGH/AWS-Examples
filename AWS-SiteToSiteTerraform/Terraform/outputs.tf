output "vpn_connection_id" {
  value = aws_vpn_connection.lab.id
}

output "vpn_tunnels" {
  value = {
    tunnel1_outside_ip = aws_vpn_connection.lab.tunnel1_address
    tunnel2_outside_ip = aws_vpn_connection.lab.tunnel2_address
  }
}

output "vgw_id" {
  value = aws_vpn_gateway.vgw.id
}

output "private_instance_ip" {
  value = aws_instance.private_web.private_ip
}
