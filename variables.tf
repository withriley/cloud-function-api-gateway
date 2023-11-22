variable "cloud_functions" {
  type = list(object({
    name     = string
    location = string
  }))
  description = "Key value pairs for the Cloud Functions that will be invoked by the API Gateway. This variable is used to configure IAM permissions for the Service Account."
}
variable "project_id" {
  type = string
  description = "The project ID where resources are deployed to"
}
variable "api_key_restrictions" {
  type    = map(object({
    ip_restrictions = string
    hostname_restrictions = string
  }))
  description = "A map of objects containing either an IP address or hostname that are allowed to access the API for each key. IPs can be a single IP address or a range specified in CIDR format. Create multiple objects for multiple keys. At least one must be specified."
  validation {
    condition     = length([for value in var.api_key_restrictions : value if value.ip_restrictions != null && length(value.ip_restrictions) > 0 || value.hostname_restrictions != null && length(value.hostname_restrictions) > 0]) > 0
    error_message = "At least one of ip_restrictions or hostname_restrictions must be specified."
  }
}
variable "gateway_id" {
  type = string
  description = "The ID of the API Gateway that will be created"
}
variable "api_spec_file" {
  type = string
  description = "The path to the OpenAPI spec file that will be used to create the API Gateway"
}