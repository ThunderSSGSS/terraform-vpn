#_____________________VPN_ENDPOINT___________________________#

resource "aws_ec2_client_vpn_endpoint" "vpn" {
    description               = var.vpn_name
    client_cidr_block         = var.client_cidr_block
    split_tunnel              = var.split_tunnel
    server_certificate_arn    = var.server_cert_arn

    authentication_options {
        type                        = "certificate-authentication"
        root_certificate_chain_arn  = var.client_root_cert_arn
    }

    connection_log_options {
        enabled = false
    }

    tags = {
        Name        = "${var.vpn_name}-endpoint"
        Environment = var.environment
        Managed_by  = var.managed_by
    }
}

#___________________SECURITY_GROUP________________________________#

resource "aws_security_group" "vpn_access" {
    vpc_id = var.vpc_id
    name = "${var.vpn_name}-sg"

    ingress {
        from_port = 0
        protocol = "-1"
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
        description = "Incoming VPN connection"
    }

    egress {
        from_port = 0
        protocol = "-1"
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Environment = var.environment
        Managed_by  = var.managed_by
    }
}

#____________________SUBNETS_ASSOCIATION__________________________#

resource "aws_ec2_client_vpn_network_association" "vpn_subnets" {
    count = length(var.subnet_ids)

    client_vpn_endpoint_id  = aws_ec2_client_vpn_endpoint.vpn.id
    subnet_id               = var.subnet_ids[count.index]
    security_groups         = [aws_security_group.vpn_access.id]

    lifecycle {
        # The issue why we are ignoring changes is that on every change
        # terraform screws up most of the vpn assosciations
        # see: https://github.com/hashicorp/terraform-provider-aws/issues/14717
        ignore_changes = [subnet_id]
    }
}

#____________________VPN_AUTH_RULE_____________________________________#

resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth_rule" {
    client_vpn_endpoint_id  = aws_ec2_client_vpn_endpoint.vpn.id
    target_network_cidr     = var.vpc_cidr_block
    authorize_all_groups    = true
}