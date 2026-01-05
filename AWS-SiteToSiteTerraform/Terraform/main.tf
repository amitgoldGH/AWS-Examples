## VPC And Subnets

resource "aws_vpc" "lab" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "lab-vpc"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id                  = aws_vpc.lab.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = false

  tags = {
    Name = "lab-private-1a"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.lab.id

  tags = {
    Name = "lab-private-rt"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private_rt.id
}

## VPC And Subnets END

## Virtual gateway and customer gateawy

resource "aws_vpn_gateway" "vgw" {
  vpc_id = aws_vpc.lab.id

  tags = {
    Name = "lab-vgw"
  }
}

resource "aws_customer_gateway" "pfsense" {
  bgp_asn    = 65000              # arbitrary private ASN;
  ip_address = var.onprem_public_ip
  type       = "ipsec.1"

  tags = {
    Name = "home-vm-pfsense-cgw"
  }
}

## Virtual gateway and customer gateawy END

## VPN Connection and routing

resource "aws_vpn_connection" "lab" {
  customer_gateway_id = aws_customer_gateway.pfsense.id
  vpn_gateway_id      = aws_vpn_gateway.vgw.id
  type                = "ipsec.1"

  # Static routing
  static_routes_only = true

  tunnel1_preshared_key = var.vpn_psk
  tunnel2_preshared_key = var.vpn_psk

  tags = {
    Name = "lab-pfsense-vpn"
  }
}

resource "aws_vpn_connection_route" "onprem" {
  vpn_connection_id      = aws_vpn_connection.lab.id
  destination_cidr_block = var.onprem_cidr
}

resource "aws_route" "to_onprem" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = var.onprem_cidr
  gateway_id             = aws_vpn_gateway.vgw.id
}

## VPN Connection END

## Security Group

resource "aws_security_group" "private_web_sg" {
  name        = "private-web-sg"
  description = "Allow HTTP and ICMP from on-prem"
  vpc_id      = aws_vpc.lab.id

  ingress {
    description = "HTTP from on-prem"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.onprem_cidr]
  }

  ingress {
    description = "ICMP from on-prem"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.onprem_cidr]
  }

  ingress {
    description = "SSH from on-prem"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.onprem_cidr]
  }

  egress {
    description = "All egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-web-sg"
  }
}
## Security Group END
## EC2 Instance
resource "aws_instance" "private_web" {
  ami                         = var.private_instance_ami
  instance_type               = var.private_instance_type
  subnet_id                   = aws_subnet.private_1a.id
  vpc_security_group_ids      = [aws_security_group.private_web_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "private-web-01"
  }
}
# EC2 Instance END
