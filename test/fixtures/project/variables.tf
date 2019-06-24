variable "billing_account" {
  description = "The ID of the billing account to which resource costs will be charged."
  type        = "string"
}

variable "real_time_enforcer" {
  default     = ""
  description = "The ID of the project in which the Real-Time Enforcer is deployed."
  type        = "string"
}

variable "folder_id" {
  default     = ""
  description = "The ID of the folder in which projects will be provisioned."
  type        = "string"
}

variable "org_id" {
  description = "The ID of the organization in which resources will be provisioned."
  type        = "string"
}

variable "shared_vpc" {
  default     = ""
  description = "The ID of the project which hosts a shared VPC."
  type        = "string"
}
