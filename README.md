# AWS VPN Terraform module

Terraform module which creates a VPN with certification based authentication.

This modules will:
* Create a client vpn endpoint;
* Create a security group with allow all access to the selected subnets.


## Requirements
The module was tested using:
| Name | Versions |
|------|----------|
| terraform | >= 1.0 |
| aws provider | >= 3.0 |

## Usage

### Creating a VPN
```hcl
# Imagine that you have same resources: 
# "aws_vpc.example", "aws_subnet.example", "aws_acm_certificate.server" and "aws_acm_certificate.ca"

module "example_vpn" {
    source                  = "github.com/ThunderSSGSS/terraform-vpn"
    vpn_name                = "my-vpn"
    vpc_id                  = aws_vpc.example.id
    vpc_cidr_block          = aws_vpc.example.cidr_block
    subnet_ids              = [aws_subnet.example.id]
    server_cert_arn         = aws_acm_certificate.server.arn
    client_root_cert_arn    = aws_acm_certificate.ca.arn
    client_cidr_block       = "10.20.0.0/22"
}
```

## Resources

| Name | Type |
|------|------|
| [aws_ec2_client_vpn_endpoint.vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_endpoint) | resource |
| [aws_security_group.vpn_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) |  resource |
| [aws_ec2_client_vpn_network_association.vpn_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_network_association) | list of resources |
| [aws_ec2_client_vpn_authorization_rule.vpn_auth_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_authorization_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpn_name | Prefix of all resources name | string | null | yes |
| environment | Tag 'Environment' of all resources | string | " " | no |
| managed_by | Tag 'Managed_by' of all resources | string | " " | no |
| vpc_id | The VPC id | string | null | yes |
| vpc_cidr_block | The VPC cidr block | string | null | yes |
| subnet_ids | List of subnets ids | list(string) | null | yes |
| server_cert_arn | The server certificate arn. The certificate must be created and validated on aws. | string | null | yes |
| client_root_cert_arn | The root certificate arn. The certificate can be created locally and exported to aws. | string | null | yes |
| client_cidr_block | The client cidr block. Range of ip that will be given to the client when connects to the vpn  | string | null | yes |
| split_tunnel | Split tunnel option. When false, all traffic will be sended to the vpn | bool | true | no |

## Outputs

| Name | Description |
|------|-------------|
| vpn_endpoint_id | Id of the vpn endpoint |


## DevInfos:
- Name: James Artur (Thunder);
- A DevOps and infrastructure enthusiastics.