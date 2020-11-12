provider "ibm" {
  generation = 2
  version = ">= 1.8.1"
  region = var.region
}
provider "null" {
}
provider "local" {
}

locals {
  vpc_zone_names = var.zone_names
  prefix_name    = var.name_prefix
  vpc_name       = "${local.prefix_name}-vpc"
  vpc_id         = var.apply ? ibm_is_vpc.vpc[0].id : ""
  subnet_ids     = var.apply ? ibm_is_subnet.vpc_subnet[*].id : []
}

data "ibm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "ibm_is_vpc" "vpc" {
  count = var.apply ? 1 : 0

  name           = local.vpc_name
  resource_group = data.ibm_resource_group.resource_group.id
}

resource "ibm_is_public_gateway" "vpc_gateway" {
  count = var.apply && var.public_gateway ? length(local.vpc_zone_names) : 0

  name           = "${local.prefix_name}-gateway-${format("%02s", count.index)}"
  vpc            = ibm_is_vpc.vpc[0].id
  zone           = local.vpc_zone_names[count.index]
  resource_group = data.ibm_resource_group.resource_group.id

  //User can configure timeouts
  timeouts {
    create = "90m"
  }
}

resource "ibm_is_subnet" "vpc_subnet" {
  count                    = var.apply ? length(local.vpc_zone_names) : 0

  name                     = "${local.prefix_name}-subnet-${format("%02s", count.index)}"
  zone                     = local.vpc_zone_names[count.index]
  vpc                      = ibm_is_vpc.vpc[0].id
  public_gateway           = var.public_gateway ? ibm_is_public_gateway.vpc_gateway[count.index].id : ""
  total_ipv4_address_count = 256
  resource_group           = data.ibm_resource_group.resource_group.id
}

resource "ibm_is_security_group_rule" "vpc_security_group_rule_tcp_k8s" {
  count     = var.apply ? length(local.vpc_zone_names) : 0

  group     = ibm_is_vpc.vpc[0].default_security_group
  direction = "inbound"
  remote    = ibm_is_subnet.vpc_subnet[count.index].ipv4_cidr_block

  tcp {
    port_min = 30000
    port_max = 32767
  }
}
