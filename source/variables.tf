variable "tfe_hostname" {
  description = "The TFE hostname"
  type        = string
}

variable "tfe_token" {
  description = "The TFE Token"
  type        = string
}

variable "organization" {
  description = "The TFE Org"
  type        = string
}

variable "workspace_count" {
  description = "How many workspaces to create"
  type        = number
}

variable "github_token" {
    description = "A GitHub OAuth token for VCS Provider"
    type = string  
}