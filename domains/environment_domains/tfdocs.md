## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_cdn_frontdoor_custom_domain.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_custom_domain) | resource |
| [azurerm_cdn_frontdoor_custom_domain_association.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_custom_domain_association) | resource |
| [azurerm_cdn_frontdoor_endpoint.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_endpoint) | resource |
| [azurerm_cdn_frontdoor_origin.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin) | resource |
| [azurerm_cdn_frontdoor_origin_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin_group) | resource |
| [azurerm_cdn_frontdoor_route.cached](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_route) | resource |
| [azurerm_cdn_frontdoor_route.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_route) | resource |
| [azurerm_dns_a_record.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_cname_record.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_cname_record) | resource |
| [azurerm_dns_txt_record.apex](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_txt_record) | resource |
| [azurerm_dns_txt_record.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_txt_record) | resource |
| [azurerm_cdn_frontdoor_profile.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/cdn_frontdoor_profile) | data source |
| [azurerm_dns_zone.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/dns_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cached_paths"></a> [cached\_paths](#input\_cached\_paths) | List of path patterns such as /packs/* that front door will cache | `list(string)` | `[]` | no |
| <a name="input_domains"></a> [domains](#input\_domains) | n/a | `any` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `any` | n/a | yes |
| <a name="input_exclude_cnames"></a> [exclude\_cnames](#input\_exclude\_cnames) | Don't create the CNAME for this record from var.domains. We set this when we want to configure front door for a services domain that we are migrating so we do not need to wait for the certificate to validate and front door to propagate the configuration. | `list` | `[]` | no |
| <a name="input_front_door_name"></a> [front\_door\_name](#input\_front\_door\_name) | n/a | `any` | n/a | yes |
| <a name="input_host_name"></a> [host\_name](#input\_host\_name) | n/a | `any` | n/a | yes |
| <a name="input_multiple_hosted_zones"></a> [multiple\_hosted\_zones](#input\_multiple\_hosted\_zones) | n/a | `bool` | `false` | no |
| <a name="input_null_host_header"></a> [null\_host\_header](#input\_null\_host\_header) | The origin\_host\_header for the azurerm\_cdn\_frontdoor\_origin resource will be var.host\_name (if false) or null (if true). If null then the host name from the incoming request will be used. | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `any` | n/a | yes |
| <a name="input_rule_set_ids"></a> [rule\_set\_ids](#input\_rule\_set\_ids) | n/a | `list(any)` | `null` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
