# template-terraform-module
A Template for creating your own Terraform Modules :robot:

![TFSec Security Checks](https://github.com/withriley/template-terraform-module/actions/workflows/main.yml/badge.svg)
![terraform-docs](https://github.com/withriley/template-terraform-module/actions/workflows/terraform-docs.yml/badge.svg)
![auto-release](https://github.com/withriley/template-terraform-module/actions/workflows/release.yml/badge.svg)

## Usage Instructions :sparkles:

1. Ensure you create your Terraform Module in the root of this directory
2. Create new examples in `/examples/`
3. Create new releases by creating tags with the name `v220317` - e.g. version by v-Year-Month-Day - also known as CalVer

## GitHub Actions

This repo has 3 built in GitHub Actions:

1. Security scan using tfsec - ensure no IaC errors. To delete remove the file `.github/workflows/main.yml`
2. Terraform-Docs - documentation is automatically taken care of by Terraform-Docs which fills in info in the `README.md` of each section.
3. Automated release - Create new releases by creating tags with the name `v220317` - e.g. version by v-Year-Month-Day - also known as CalVer.

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

## Detailed TF Module Requirements :books:

1. Root module. This is the only required element for the standard module structure. Terraform files must exist in the root directory of the repository. This should be the primary entrypoint for the module and is expected to be opinionated. For the Consul module the root module sets up a complete Consul cluster. It makes a lot of assumptions however, and we expect that advanced users will use specific nested modules to more carefully control what they want.

2. README. The root module and any nested modules should have README files. This file should be named README or README.md. The latter will be treated as markdown. There should be a description of the module and what it should be used for. If you want to include an example for how this module can be used in combination with other resources, put it in an examples directory like this. Consider including a visual diagram depicting the infrastructure resources the module may create and their relationship.

3. LICENSE. The license under which this module is available. If you are publishing a module publicly, many organizations will not adopt a module unless a clear license is present. We recommend always having a license file, even if it is not an open source license.

4. main.tf, variables.tf, outputs.tf. These are the recommended filenames for a minimal module, even if they're empty. main.tf should be the primary entrypoint. For a simple module, this may be where all the resources are created. For a complex module, resource creation may be split into multiple files but any nested module calls should be in the main file. variables.tf and outputs.tf should contain the declarations for variables and outputs, respectively.

5. Variables and outputs should have descriptions. All variables and outputs should have one or two sentence descriptions that explain their purpose. This is used for documentation. See the documentation for variable configuration and output configuration for more details.

6. Nested modules. Nested modules should exist under the modules/ subdirectory. Any nested module with a README.md is considered usable by an external user. If a README doesn't exist, it is considered for internal use only. These are purely advisory; Terraform will not actively deny usage of internal modules. Nested modules should be used to split complex behavior into multiple small modules that advanced users can carefully pick and choose. For example, the Consul module has a nested module for creating the Cluster that is separate from the module to setup necessary IAM policies. This allows a user to bring in their own IAM policy choices.

7. Examples. Examples of using the module should exist under the examples/ subdirectory at the root of the repository. Each example may have a README to explain the goal and usage of the example. Examples for submodules should also be placed in the root examples/ directory.

8. Because examples will often be copied into other repositories for customization, any module blocks should have their source set to the address an external caller would use, not to a relative path.