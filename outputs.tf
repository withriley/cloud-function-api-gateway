output "gateway_url" {
  value = google_api_gateway_gateway.api_gw.default_hostname
  description = "The URL of the API Gateway"
}
output "iam_enabled_functions" {
  value = google_cloud_run_service_iam_member.default[*].id
  description = "The cloud functions that have been configured with the IAM role 'roles/run.invoker'"
}
output "key_ids" {
  value = [for s in google_apikeys_key.default : s.id]
  description = "The IDs of the API keys that have been created"
}