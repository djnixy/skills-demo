stack {
  name        = "doks"
  description = "doks"
  id          = "doks"
}

import {
  source = "/terramate/digitalocean/*.tm.hcl"
}

import {
  source = "/terramate/digitalocean/kubernetes/*.tm.hcl"
}