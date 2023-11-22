# Cloud Function API Gateway Terraform Module 🛠️

This Terraform module configures an API Gateway that is backed by one or more Cloud Functions.

It includes:

- Creation of API keys with restrictions (either IP or hostname based)
- Creation of the API Gateway and relevant configurations
- Creation of a Service Account that is used by the API Gateway to invoke the Cloud Functions (and required permissions)

## Assumptions and caveats :warning:

- Cloud Functions must be configured with public ingress. Do not allow unauthenticated invocations - this module will configure IAM permissions for the API Gateway to invoke the Cloud Functions. 
- Only Gen 2 Cloud Functions are supported by this module. 
- All resources must be in the same project. 
- The Cloud Functions defined in the OpenAPI spec must also be specified in the `cloud_functions` variable so that we can configure IAM permissions for the API Gateway. 
- The `api_spec_file` variable must be a path to the OpenAPI spec YAML file in the same directory as the Terraform configuration file (see example below).
- When specifying the `api_key_restrictions` variable, at least one of `ip_restrictions` or `hostname_restrictions` must be specified (ie. not both). 

## API Key Requirements + OpenAPI spec example :heavy_check_mark:

The `security` and `securityDefinitions` section of the OpenAPI spec must be configured as follows for API authentication to work with GCP keys. 

````
# openapi2-functions.yaml
swagger: '2.0'
info:
  title: Super Fast API
  description: Sample API on API Gateway with a Google Cloud Functions backend
  version: 1.0.0
schemes:
  - https
produces:
  - application/json
paths:
  /hello:
    post:
      summary: Greet a user
      operationId: hello
      x-google-backend:
        address: https://australia-southeast2-sandboxproject.cloudfunctions.net/hello-world
      security:
        - api_key: []
      responses:
       '200':
          description: A successful response
          schema:
            type: string
securityDefinitions:
  api_key:
    type: "apiKey"
    name: "key"
    in: "query"
````

<!-- BEGIN_TF_DOCS -->


## Example

```hcl
module "api_gateway" {
  source = "../cloud-function-api-gateway"
  project_id = "sandbox"
  api_key_restrictions = {
    key1 = {
        ip_restrictions = ""
        hostname_restrictions = "www.google.com"
    }
  }
  gateway_id = "api1"
  cloud_functions = [{
    name = "hello-world"
    location = "australia-southeast2"
  }]
  api_spec_file = "open-api.yaml"
}
```

## Resources

| Name | Type |
|------|------|
| [google-beta_google_api_gateway_api.api_gw](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_api_gateway_api) | resource |
| [google-beta_google_api_gateway_api_config.api_gw](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_api_gateway_api_config) | resource |
| [google-beta_google_api_gateway_gateway.api_gw](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_api_gateway_gateway) | resource |
| [google-beta_google_project_service.api](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_project_service) | resource |
| [google_apikeys_key.ip](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/apikeys_key) | resource |
| [google_cloud_run_service_iam_member.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_member) | resource |
| [google_project_iam_member.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.apigw](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [random_id.default](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [time_sleep.wait_5_minutes](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [google_cloudfunctions2_function.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/cloudfunctions2_function) | data source |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_key_restrictions"></a> [api\_key\_restrictions](#input\_api\_key\_restrictions) | A map of objects containing either lists of IP addresses and/or hostnames that are allowed to access the API for each key. IPs can be a single IP address or a range specified in CIDR format. Create multiple objects for multiple keys. At least one must be specified. | <pre>map(object({<br>    ip_restrictions       = list(string)<br>    hostname_restrictions = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_api_spec_file"></a> [api\_spec\_file](#input\_api\_spec\_file) | The path to the OpenAPI spec file that will be used to create the API Gateway | `string` | n/a | yes |
| <a name="input_cloud_functions"></a> [cloud\_functions](#input\_cloud\_functions) | Key value pairs for the Cloud Functions that will be invoked by the API Gateway. This variable is used to configure IAM permissions for the Service Account. | <pre>list(object({<br>    name     = string<br>    location = string<br>  }))</pre> | n/a | yes |
| <a name="input_gateway_id"></a> [gateway\_id](#input\_gateway\_id) | The ID of the API Gateway that will be created | `string` | n/a | yes |
| <a name="input_gateway_name"></a> [gateway\_name](#input\_gateway\_name) | The name of the API Gateway that will be created | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID where resources are deployed to | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to deploy the API Gateway to. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
