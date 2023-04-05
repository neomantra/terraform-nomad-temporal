# terraform-nomad-temporal

https://github.com/neomantra/terraform-nomad-temporal

## WORK IN PROGRESS

This Terraform module stands up a [Temporal](https://temporal.io) Application Server on a [Nomad Cluster](https://nomadproject.io).

The Persistence Store is via a Postgres database, provisioned using [Neomantra's branch](https://github.com/neomantra/terraform-nomad-postgres/tree/nm-work) of the  `terraform-nomad-postgres` module.

Assumes Traefik Routing and Consul, optionally with Vault.

Initial work from this [Just-in-Time Nomad: Running Temporal on Nomad](https://faun.pub/just-in-time-nomad-running-temporal-on-nomad-5fee139f37ea) blog post.


### License

Authored by [Evan Wies](https://github.com/neomantra).

Copyright (c) 2023 Neomantra BV.

Released under the MIT License, see `LICENSE`.