data "aws_vpc" "vpc" {
  id = var.vpc_id
}
data "aws_subnet" "subnet" {
  id = var.subnet_id
}
data "aws_ssm_parameter" "amazonlinux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-arm64"
}
data "aws_route53_zone" "zone" {
  name = var.route53_zone
}

resource "aws_security_group" "shadowsocks" {
  name        = "shadowsocks"
  description = "shadowsocks"
  vpc_id      = data.aws_vpc.vpc.id

  egress {
    description = "Allow all outbound traffic by default"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    description = "Public Shadowsocks Server"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    description = "Public SSH Server"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.trusted_ips
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"

  name = "shadowsocks"

  instance_type               = var.instance_type
  key_name                    = var.key_name
  ami                         = data.aws_ssm_parameter.amazonlinux_2023.value
  monitoring                  = true
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.shadowsocks.id]
  subnet_id                   = data.aws_subnet.subnet.id
  user_data                   = base64encode(templatefile("${path.module}/user_data/setup-shadowsocks.sh", {
    PORT     = var.port,
    PASSWORD = var.password,
    VERSION  = var.shadowsocks_version,
  }))
}

resource "aws_route53_record" "shadowsocks" {
  name    = "shadowsocks.${data.aws_route53_zone.zone.name}"
  type    = "A"
  zone_id = data.aws_route53_zone.zone.zone_id
  ttl     = 60
  records = [module.ec2_instance.public_ip]
}
