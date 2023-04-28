# terraform-nomad-temporal
# https://github.com/neomantra/terraform-nomad-temporal
#
# examples/hello/main.tf
#
# Copyright (c) Neomantra BV 2023. All rights reserved.

# You must set your environment variable NOMAD_ADDR for this to work, for example:
#    export NOMAD_ADDR=http://localhost:4646

# Simple example of standing up Temporal Server with Nomad

terraform {
  required_providers {
    nomad = {
      source = "hashicorp/nomad"
    }
  }
}

resource "nomad_namespace" "temporal" {
  name        = "temporal"
  description = "temporal namespace"
}

module "temporal" {
  source = "github.com/neomantra/terraform-nomad-temporal"

  base_name = "temporal"

  temporal_autosetup_tag = "1.20.2"
  temporal_ui_tag        = "2.14.0"

  nomad_namespace   = nomad_namespace.temporal.name
  nomad_datacenters = []

  # For Traefik routing
  service_dns_name = "temporal.example.com"
  http_entrypoints = "https,http"
  prom_entrypoints = "http"

  use_prometheus = true

  admin_user     = "hello"
  admin_password = "world"
  vault_secret = {
    use_vault_provider      = false,
    vault_kv_path           = ""
    vault_kv_policy_name    = ""
    vault_kv_field_username = ""
    vault_kv_field_password = ""
  }
}
