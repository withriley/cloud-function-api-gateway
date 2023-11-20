# Cloud Function API Gateway Terraform Module 🛠️
A Template for creating your own Terraform Modules :robot:

## Assumptions and caveats :warning:

- You MUST specify either the `ip_restrictions` or `hostname_restrictions` variable. If you do not specify either of these variables, no API keys will be created and the API will not be accesible (assuming of course you've configured your OpenAPI spec to require keys!)
- Cloud Functions must be configured with public ingress. Do not allow unauthenticated invocations - this module will configure IAM permissions for the API Gateway to invoke the Cloud Functions. 
- All resources must be in the same project
- The Cloud Functions defined in the OpenAPI spec must also be specified in the `cloud_functions` variable so that we can configure IAM permissions for the API Gateway. 

## API Key Requirements :heavy_check_mark:

The `security` and `securityDefinitions` section of the OpenAPI spec must be configured as follows for API authentication to work with GCP keys. 

````
paths:
  /hello:
    post:
      summary: Greet a user
      operationId: hello
      x-google-backend:
        address: https://australia-southeast2-gcpproject.cloudfunctions.net/hello-world
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

```

## Resources

| Name | Type |
|------|------|
| [google-beta_google_api_gateway_api.api_gw](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_api_gateway_api) | resource |
| [google-beta_google_api_gateway_api_config.api_gw](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_api_gateway_api_config) | resource |
| [google-beta_google_api_gateway_gateway.api_gw](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_api_gateway_gateway) | resource |
| [google-beta_google_project_service.api](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_project_service) | resource |
| [google_apikeys_key.hostname](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/apikeys_key) | resource |
| [google_apikeys_key.ip](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/apikeys_key) | resource |
| [google_cloud_run_service_iam_member.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_member) | resource |
| [google_project_iam_member.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.apigw](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [null_resource.previous](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_id.default](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [time_sleep.wait_5_minutes](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [google_cloudfunctions2_function.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/cloudfunctions2_function) | data source |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_functions"></a> [cloud\_functions](#input\_cloud\_functions) | Key value pairs for the Cloud Functions that will be invoked by the API Gateway. This variable is used to configure IAM permissions for the Service Account. | <pre>list(object({<br>    name     = string<br>    location = string<br>  }))</pre> | n/a | yes |
| <a name="input_hostname_restrictions"></a> [hostname\_restrictions](#input\_hostname\_restrictions) | A list of the hostnames/websites that are allowed to access the API. | `list(string)` | `[]` | no |
| <a name="input_ip_restrictions"></a> [ip\_restrictions](#input\_ip\_restrictions) | A list of the IP addresses that are allowed to access the API. Can be a single IP address or a range specified in CIDR format. | `list(string)` | `[]` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID where resources are deployed to | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
