variable "sf_username" {
   type      = string
   sensitive = true
}
variable "sf_password" {
  type      = string
  sensitive = true
}
variable "sf_account" {
  type      = string
   
}
variable "sf_org_name" {
  type      = string
   
}
variable "sf_account_identity" {
  type      = string
   sensitive = true
}
variable "environment" {
  type = string
  
}