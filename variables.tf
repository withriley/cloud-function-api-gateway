variable "cloud_run_functions" {
  type = list(object({
    name     = string
    location = string
  }))
  description = "Key value pairs for the cloud run jobs that will be invoked by the API Gateway. This variable is used to configure IAM permissions for the Service Account."
}

variable "project_id" {
  type = string
  description = "The project ID where resources are deployed to"
}

// One of the following must be specified to create an API key (both can be specified for hostname and IP based restrictions)
// For each IP address/range and hostname one API key will be created 
variable "ip_restrictions" {
  type    = list(string)
  default = []
  description = "A list of the IP addresses that are allowed to access the API. Can be a single IP address or a range specified in CIDR format."
}
variable "hostname_restrictions" {
  type    = list(string)
  default = []
  description = "A list of the hostnames/websites that are allowed to access the API."
}