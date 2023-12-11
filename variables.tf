variable "cloud_functions" {
  type = list(object({
    name     = string
    location = string
  }))
  description = "Key value pairs for the Cloud Functions that will be invoked by the API Gateway. This variable is used to configure IAM permissions for the Service Account."
}
variable "project_id" {
  type        = string
  description = "The project ID where resources are deployed to"
}
variable "api_key_restrictions" {
  type = map(object({
    ip_restrictions       = optional(list(string), [])
    hostname_restrictions = optional(list(string), [])
  }))
  description = "A map of objects containing either lists of IP addresses or hostnames that are allowed to access the API for each key. Create multiple objects for multiple keys."
  validation {
    condition = alltrue([
      for key, value in var.api_key_restrictions : (
        (length(value.ip_restrictions) == 0 || length(value.hostname_restrictions) == 0) && (length(value.ip_restrictions) > 0 || length(value.hostname_restrictions) > 0) && can(regex("^[A-Za-z0-9-]+$", key))
        # At least one of these lists must be empty. IP and Host restrictions cannot be configured on the same key. 
        # At least one of these lists must have at least one item (ie. at least one restriction specified)
        # The key of the map must be alphanumeric
      )
    ])
    error_message = "Exactly one of 'ip_restrictions' or 'hostname_restrictions' must be specified for each API key. IP and Host restrictions cannot be configured on the same key. Map keys must be alphanumeric (the key name)."
  }
}
variable "gateway_id" {
  type        = string
  description = "The ID of the API Gateway that will be created"
}
variable "gateway_name" {
  type        = string
  description = "The name of the API Gateway that will be created"
}
variable "api_spec_file" {
  type        = string
  description = "The path to the OpenAPI spec file that will be used to create the API Gateway"
}
variable "region" {
  type        = string
  description = "The region to deploy the API Gateway to."
}
