
variable "region" {
  description = "Name of the AWS region."
  type        = string
}

variable "cidr" {
  description = "The CIDR for the VPC."
  type        = string
}

variable "name" {
  description = "Name of the VPC."
  type        = string
}

variable "environment" {
  description = "The environment this VPC belongs to."
  type        = string
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames."
  default     = "true"
}

variable "enable_dns_support" {
  description = "Enable DNS support."
  default     = "true"
}

variable "enable_classiclink" {
  description = "Enable ClassicLink."
  default     = "false"
}

variable "enable_classiclink_dns_support" {
  description = "Enable ClassicLink DNS support."
  default     = "false"
}

variable "assign_generated_ipv6_cidr_block" {
  description = "Assign generated IPv6 CIDR block."
  default     = "false"
}

variable "zones" {
  description = "A list of the availability zones to use."
  type        = list(string)
}

variable "private" {
  description = "A list of the private subnet CIDR blocks."
  type        = list(string)
}

variable "public" {
  description = "A list of the public subnet CIDR blocks."
  type        = list(string)
}

