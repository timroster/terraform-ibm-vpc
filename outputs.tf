#output "myoutput" {
#  description = "Description of my output"
#  value       = "value"
#  depends_on  = [<some resource>]
#}

output "name" {
  value       = local.vpc_name
  depends_on  = [ibm_is_vpc.vpc]
  description = ""
}

output "id" {
  value       = local.vpc_id
  description = ""
}

output "zone_names" {
  value       = local.vpc_zone_names
  description = "The list of zone names that into which subnets were created"
}

output "subnet_ids" {
  value       = local.subnet_ids
  description = "The list of subnet ids"
}
