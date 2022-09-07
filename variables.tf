# Input Variable Definition

variable "name" {
  description = "Name of the VPC"
  type        = string
  default     = ""
}

variable "cidr" {
  description = "VPC CIDR Block"
  type        = string
  default     = "0.0.0.0/0"
}

variable "dns_support" {
  description = "Enable/disable DNS support"
  type        = bool
  default     = true
}

variable "dns_hostname" {
  description = "Enable/disable DNS hostnames"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = "A map of tags to assign to the VPC"
  type        = map(string)
  default     = {}
}

variable "igw_tags" {
  description = "Additional tags for the internet gateway"
  type        = map(string)
  default     = {}
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string) # string
  default     = []           # ""
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string) # string
  default     = []           # ""
}

variable "public_ip_on_launch" {
  description = "Map public IP for the subnet"
  type = bool
  default = false
}

variable "public_subnet_suffix" {
  description = "Suffix to append to public subnets name"
  type        = string
  default     = "public"
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "private"
}

variable "public_route_table_tags" {
  description = "Additional tags for the public route tables"
  type        = map(string)
  default     = {}
}

variable "private_route_table_tags" {
  description = "Additional tags for the private route tables"
  type        = map(string)
  default     = {}
}
