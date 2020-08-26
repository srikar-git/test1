provider "ibm"{
  ic_api_key=""
}
data "ibm_resource_group" "web_group" {
  name = "Default"
}
data "ibm_cis" "web_instance" {
  name              = "CISTest"
  resource_group_id = data.ibm_resource_group.web_group.id
}
data "ibm_cis_domain" "web_domain" {
  cis_id = data.ibm_cis.web_instance.id
  domain = "cis-terraform.com"
}
resource "ibm_cis_dns_record" "examplednsa" {
  cis_id           = data.ibm_cis.web_instance.id
  domain_id        = data.ibm_cis_domain.web_domain.domain_id
  name      = "@"
  content   = "1.2.3.4"
  type      = "A"
}
