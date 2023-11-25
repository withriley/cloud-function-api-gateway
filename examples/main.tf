module "api_gateway" {
  source     = "../cloud-function-api-gateway"
  project_id = "sandbox"
  api_key_restrictions = {
    key1 = {
      hostname_restrictions = "www.google.com"
    }
  }
  gateway_id   = "api1"
  gateway_name = "api_gateway"
  cloud_functions = [{
    name     = "hello-world"
    location = "australia-southeast2"
  }]
  api_spec_file = "open-api.yaml"
}
