variable "ic_api_key"{}
variable "name"{
  type    = string
  default = "somevalue"
}
provider "ibm"{
  ibmcloud_api_key=var.ic_api_key
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
resource "null_resource" "test_name" {
  triggers = {
    uuid = uuid()
  }
    
  provisioner "local-exec" {
    command = "echo - This val ${var.name}"
  }
}
resource "ibm_cis_dns_record" "examplednsa" {
  cis_id           = data.ibm_cis.web_instance.id
  domain_id        = data.ibm_cis_domain.web_domain.id
  name      = var.name
  content   = "1.2.3.4"
  type      = "A"
  proxied = true
}
resource "ibm_cis_dns_record" "dns_mx_1" {
  cis_id           = data.ibm_cis.web_instance.id
  domain_id        = data.ibm_cis_domain.web_domain.id
  name      = "sample"
  ttl       = 3600
  type      = "MX"
  priority  = "0"
  content   = "xyz.mail.protection.outlook.com"
}
