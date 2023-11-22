// TO DO: Create an example
// TO DO: Uplift the way that hostnames and IP addresses are specified to allow for more complex configurations

// locals
locals {
  configmd5 = md5(file("${path.cwd}/${var.api_spec_file}")) # this generates an md5 hash so that the api config name is unique whenever the config changes
  apis      = ["apikeys.googleapis.com", "apigateway.googleapis.com"]
}

// enable required APIs for this module
resource "google_project_service" "apigw" {
  for_each = toset(local.apis)
  project  = var.project_id
  service  = each.key

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_on_destroy = false
}

// create random suffix for resources to ensure uniqueness
resource "random_id" "default" {
  byte_length = 2
}

// create google cloud service account
resource "google_service_account" "default" {
  project      = var.project_id
  account_id   = "api-gw-service-account-${random_id.default.hex}"
  display_name = "Service Account created by TF API GW module"
}

// get cloud functions
data "google_cloudfunctions2_function" "default" {
  count    = length(var.cloud_functions)
  project  = var.project_id
  name     = var.cloud_functions[count.index].name
  location = var.cloud_functions[count.index].location
}

// add "roles/run.invoker" to each cloud function
resource "google_cloud_run_service_iam_member" "default" {
  count    = length(data.google_cloudfunctions2_function.default)
  location = data.google_cloudfunctions2_function.default[count.index].location
  project  = var.project_id
  service  = data.google_cloudfunctions2_function.default[count.index].name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.default.email}"
}

// add Cloud API Gateway Service Agent role to service account
resource "google_project_iam_member" "default" {
  project = var.project_id
  role    = "roles/apigateway.serviceAgent"
  member  = "serviceAccount:${google_service_account.default.email}"
}

// Create API GW + Configs 
resource "google_api_gateway_api" "api_gw" {
  provider     = google-beta
  project      = var.project_id
  api_id       = "${var.gateway_id}-${random_id.default.hex}"
  display_name = var.gateway_name
}

resource "google_api_gateway_api_config" "api_gw" {
  provider      = google-beta
  project       = var.project_id
  api           = google_api_gateway_api.api_gw.api_id
  api_config_id = "${var.gateway_id}-config-${local.configmd5}"
  display_name  = var.gateway_name

  openapi_documents {
    document {
      path     = "spec.yaml"
      contents = filebase64("${path.cwd}/${var.api_spec_file}")
    }
  }
  gateway_config {
    backend_config {
      google_service_account = google_service_account.default.email
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_api_gateway_gateway" "api_gw" {
  provider     = google-beta
  project      = var.project_id
  region       = var.region
  api_config   = google_api_gateway_api_config.api_gw.id
  gateway_id   = "${var.gateway_id}-${random_id.default.hex}"
  display_name = var.gateway_name
}

// sleep 5 minutes to wait for API to become available - requried to enable API via "google_project_service" resource
resource "time_sleep" "wait_5_minutes" {
  depends_on = [google_api_gateway_gateway.api_gw]

  create_duration = "300s"
}

// enable API for usage via API keys 
resource "google_project_service" "api" {
  project  = var.project_id
  service  = google_api_gateway_api.api_gw.managed_service
  provider = google-beta
  timeouts {
    create = "10m"
    update = "15m"
  }

  disable_dependent_services = false
  disable_on_destroy         = false

  depends_on = [time_sleep.wait_5_minutes]
}

// create API keys with source ip based restrictions
resource "google_apikeys_key" "ip" {
  for_each     = var.api_key_restrictions
  name         = "apigw-key-ip-${each.key}"
  display_name = "api gateway key for: ${each.key} - created by TF"
  project      = var.project_id

  restrictions {
    api_targets {
      service = google_api_gateway_api.api_gw.managed_service
    }
    server_key_restrictions {
      allowed_ips = each.value.ip_restrictions
    }
    browser_key_restrictions {
      allowed_referrers = each.value.hostname_restrictions
    }
  }
  depends_on = [google_project_service.api]
}
