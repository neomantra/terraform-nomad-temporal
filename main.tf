# terraform-nomad-temporal
# https://github.com/neomantra/terraform-nomad-temporal
#
# main.tf
#
# Copyright (c) Neomantra BV 2023. All rights reserved.


# required provider is Nomad


# Our Postgres database for state
module "postgres" {
  source = "github.com/neomantra/terraform-nomad-postgres.git?ref=nm-work"

  # nomad
  nomad_datacenters = var.nomad_datacenters
  nomad_namespace   = var.nomad_namespace

  # consul
  #consul_tags = ["xsdb-test", "postgres", "test"]

  # postgres
  service_name    = "${var.base_name}-pg"
  container_image = "postgres:15-alpine"
  database        = "temporal"
  #pg_isready_path                 = "/usr/bin/pg_isready"
  use_static_port = false
  #use_canary                      = true
  use_connect = false
  #container_environment_variables = ["PGDATA=/home/postgres/pgdata"]
  #volume_destination              = "/home/postgres/pgdata"
  vault_secret = {
    use_vault_provider      = var.vault_secret.use_vault_provider,
    vault_kv_path           = var.vault_secret.vault_kv_path,
    vault_kv_policy_name    = var.vault_secret.vault_kv_policy_name,
    vault_kv_field_username = var.vault_secret.vault_kv_field_username,
    vault_kv_field_password = var.vault_secret.vault_kv_field_password
  }
  nomad_csi_volume       = "${var.base_name}-pg"
  nomad_csi_volume_extra = <<EOT
      attachment_mode = "file-system"
      access_mode     = "multi-node-multi-writer"
EOT
  nomad_task_extra       = <<EOT
        user = 70
EOT
  memory                 = 1800
  cpu                    = 1100
}

# Nomad job running a Temporal Cluster (single node right now)
resource "nomad_job" "temporal" {
  jobspec = templatefile("${path.module}/files/temporal.nomad.hcl.j2", {
    USERNAME                   = var.admin_user
    PASSWORD                   = var.admin_password
    NOMAD_DATACENTERS_JSON     = jsonencode(var.nomad_datacenters)
    NOMAD_REGION               = var.nomad_region
    NOMAD_NAMESPACE            = var.nomad_namespace
    TEMPORAL_AUTOSETUP_IMAGE   = var.temporal_autosetup_image
    TEMPORAL_AUTOSETUP_TAG     = var.temporal_autosetup_tag
    TEMPORAL_ADMIN_TOOLS_IMAGE = var.temporal_admin_tools_image
    TEMPORAL_ADMIN_TOOLS_TAG   = var.temporal_admin_tools_tag
    TEMPORAL_UI_IMAGE          = var.temporal_ui_image
    TEMPORAL_UI_TAG            = var.temporal_ui_tag
    PG_SERVICE_NAME            = "${var.base_name}-pg"
    USE_VAULT_PROVIDER         = var.vault_secret.use_vault_provider
    VAULT_KV_POLICY_NAME       = var.vault_secret.vault_kv_policy_name
    VAULT_KV_PATH              = var.vault_secret.vault_kv_path
    VAULT_KV_FIELD_USERNAME    = var.vault_secret.vault_kv_field_username
    VAULT_KV_FIELD_PASSWORD    = var.vault_secret.vault_kv_field_password
    SERVICE_DNS_NAME           = var.service_dns_name
    HTTP_ENTRYPOINTS           = var.http_entrypoints
    GRPC_ENTRYPOINTS           = var.grpc_entrypoints
    PROM_ENTRYPOINTS           = var.prom_entrypoints
    USE_PROMETHEUS             = var.use_prometheus
  })
}
