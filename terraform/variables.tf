variable "instance_type" {
    type = string
    default = "t4g.nano"
}
variable "port" {
  type = number
  default = 1480
}
variable "shadowsocks_version" {
    type = string
    default = "1.15.4"
}
variable "key_name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_id" { type = string }
variable "trusted_ips" { type = list(string) }
variable "route53_zone" { type = string }
variable "password" { type = string }
