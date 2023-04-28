# terraform-nomad-temporal

https://github.com/neomantra/terraform-nomad-temporal

## WORK IN PROGRESS 

### Overview

This Terraform module stands up a [Temporal](https://temporal.io) Application Server on a [Nomad Cluster](https://nomadproject.io).

The Persistence Store is via a Postgres database, provisioned using [Neomantra's branch](https://github.com/neomantra/terraform-nomad-postgres/tree/nm-work) of the  `terraform-nomad-postgres` module.

Currently it is opinionated and assumes Docker, Consul, some networking, and Traefik Routing. It can optionally use Vault.

Initial work from this [Just-in-Time Nomad: Running Temporal on Nomad](https://faun.pub/just-in-time-nomad-running-temporal-on-nomad-5fee139f37ea) blog post.  Like that blog helped me figure it out, hopefully you this module helps you.

It also has not been hardened or tested for production use.

## Example

You can use this module by referencing `source = "github.com/neomantra/terraform-nomad-temporal"` in your `module` stanza.  Excerpt from the [examples/hello/main.tf](examples/hello/main.tf) file:

```
module "temporal" {
  source = "github.com/neomantra/terraform-nomad-temporal"

  base_name = "temporal"

  temporal_autosetup_tag = "1.20.2"
  temporal_ui_tag        = "2.14.0"

  nomad_namespace   = nomad_namespace.temporal.name
  nomad_datacenters = ["dc1"]

  # For Traefik routing
  service_dns_name = "temporal.example.com"
  http_entrypoints = "https,http"
  prom_entrypoints = "http"

  use_prometheus = true

  admin_user     = "hello"
  admin_password = "world"
}
```


To see it in action, do this:

```
# Make sure Docker is running... however you do that...

# In one terminal, start Nomad:
nomad agent -dev -bind 0.0.0.0

# In another terminal, go to the examples directory and Terraform away
export NOMAD_ADDR=http://localhost:4646
cd examples/hello
terraform init
terraform apply
```

After a while, you should see the Temporal:
 * As a job in the Nomad UI: http://localhost:4646/ui/jobs/temporal@temporal
 * And see the Temporal UI via Traefik or directly by seeing the allocation's ports 

This doesn't work in MacOS due to bridge networking.
  
### License

Authored by [Evan Wies](https://github.com/neomantra).

Copyright (c) 2023 Neomantra BV.

Released under the MIT License, see `LICENSE`.