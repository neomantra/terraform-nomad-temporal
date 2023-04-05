# terraform-nomad-temporal
# https://github.com/neomantra/terraform-nomad-temporal
#
# variables.tf
#
# Copyright (c) Neomantra BV 2023. All rights reserved.

###########################################################
## General ################################################

variable "base_name" {
  type        = string
  description = "Base name for services"
  default     = "temporal"
}

###########################################################
## Nomad ##################################################

variable "nomad_region" {
  type        = string
  description = "Nomad Region"
  default     = "global"
}

variable "nomad_datacenters" {
  type        = list(string)
  description = "Nomad Datacenters"
  default     = []
}

variable "nomad_namespace" {
  type        = string
  description = "Nomad Namespace"
  default     = "temporal"
}

variable "nomad_pg_task_extra" {
  type        = string
  description = "Extra config to inject in Nomad's task config stanza"
  default     = ""
}

###########################################################
## Database ###############################################

variable "admin_user" {
  type        = string
  description = "Postgres admin user"
  default     = "postgres"
}

variable "admin_password" {
  type        = string
  description = "Postgres admin password"
  default     = "postgres"
}

variable "vault_secret" {
  type = object({
    use_vault_provider      = bool,
    vault_kv_policy_name    = string,
    vault_kv_path           = string,
    vault_kv_field_username = string,
    vault_kv_field_password = string
  })
  description = "Set of properties to be able to fetch secret from vault"
  default = {
    use_vault_provider      = true
    vault_kv_policy_name    = "kv-secret"
    vault_kv_path           = "secret/data/postgres"
    vault_kv_field_username = "username"
    vault_kv_field_password = "password"
  }
}


###########################################################
## Temporal ###############################################

variable "temporal_autosetup_image" {
  type        = string
  description = "Temporal autosetup image name"
  default     = "temporalio/auto-setup"
}

variable "temporal_autosetup_tag" {
  type        = string
  description = "Temporal autosetup mage tag"
  default     = "1.20.1"
}

variable "temporal_admin_tools_image" {
  type        = string
  description = "Temporal admin-tools image name"
  default     = "temporali/admin-tools"
}

variable "temporal_admin_tools_tag" {
  type        = string
  description = "Temporal admin-tools image tag"
  default     = "1.20.1"
}

variable "temporal_ui_image" {
  type        = string
  description = "Temporal UI image name"
  default     = "temporalio/ui"
}

variable "temporal_ui_tag" {
  type        = string
  description = "Temporal UI image tag"
  default     = "2.13.3"
}


###########################################################
## Traefik ################################################

variable "service_dns_name" {
  type        = string
  description = "DNS name for service registration and Traefik routing"
}

variable "http_entrypoints" {
  type        = string
  description = "Traefik entrypoints for http web interface"
}

variable "grpc_entrypoints" {
  type        = string
  description = "Traefik entrypoints for grpc API interface"
  default     = "grpc"
}
