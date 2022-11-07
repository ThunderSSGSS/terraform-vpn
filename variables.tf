variable "environment" {
    type    = string
    default = ""
}
variable "managed_by" {
    type    = string
    default = ""
}

variable "vpn_name" { type = string }


#________VPC_INFOS__________________#

variable "vpc_id" { type = string }
variable "vpc_cidr_block" { type = string }
variable "subnet_ids" { type = list(string) }

#_______VPN_INFOS__________________#

variable "server_cert_arn" { type = string }
variable "client_root_cert_arn" { type = string }
variable "client_cidr_block" { type = string } # ex: "10.20.0.0/22"

variable "split_tunnel" {
    type    = bool
    default = true
}