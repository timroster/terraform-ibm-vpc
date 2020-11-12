# Resource Group Variables
variable "resource_group_name" {
  type        = string
  description = "The name of the IBM Cloud resource group where the cluster will be created/can be found."
}

variable "region" {
  type        = string
  description = "The IBM Cloud region where the cluster will be/has been installed."
}

variable "prefix_name" {
  type        = string
  description = "The name of the vpc resource"
}

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud api token"
}

# VPC Variables
variable "vpc_zone_names" {
  type        = list(string)
  description = "List of vpc zones"
  default     = []
}

variable "public_gateway" {
  type        = bool
  description = "Flag indicating that a public gateway should be created"
  default     = true
}

variable "apply" {
  type        = bool
  description = "Flag indicating that the module should be applied"
  default     = true
}

variable "exists" {
  type        = bool
  description = "Flag indicating that the VPC already exists and we should just look up the values"
  default     = true
}

variable "gitops_dir" {
  type        = string
  description = "Directory where the gitops repo content should be written"
  default     = ""
}
