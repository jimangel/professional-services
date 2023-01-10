/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# tfdoc:file:description Production spoke DNS zones and peerings setup.

# GCP-specific environment zone

module "prod-dns-private-zone" {
  source          = "../modules/dns"
  project_id      = module.prod-spoke-project.project_id
  type            = "private"
  name            = "prod-gcp-example-com"
  domain          = "prod.gcp.example.com."
  client_networks = [module.common-vpc.self_link]
  recordsets = {
    "A localhost" = { records = ["127.0.0.1"] }
  }
}

# root zone peering to common to centralize configuration; remove if unneeded

module "prod-common-root-dns-peering" {
  source          = "../modules/dns"
  project_id      = module.prod-spoke-project.project_id
  type            = "peering"
  name            = "prod-root-dns-peering"
  domain          = "."
  client_networks = [module.prod-spoke-vpc.self_link]
  peer_network    = module.common-vpc.self_link
}

module "prod-reverse-10-dns-peering" {
  source          = "../modules/dns"
  project_id      = module.prod-spoke-project.project_id
  type            = "peering"
  name            = "prod-reverse-10-dns-peering"
  domain          = "10.in-addr.arpa."
  client_networks = [module.prod-spoke-vpc.self_link]
  peer_network    = module.common-vpc.self_link
}
