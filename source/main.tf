terraform {
  required_providers {
    tfe = {
      version = "~> 0.39.0"
    }
  }
}

provider "tfe" {
  hostname = var.tfe_hostname
  token    = var.tfe_token
}

resource "tfe_oauth_client" "github" {
  name             = "GitHub"
  organization     = var.organization
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_token
  service_provider = "github"
}

resource "tfe_registry_module" "test-registry-module" {
  vcs_repo {
    display_identifier = "ventingcloud/terraform-tfe-workspacer"
    identifier         = "ventingcloud/terraform-tfe-workspacer"
    oauth_token_id     = tfe_oauth_client.github.oauth_token_id
  }
}

module "workspacer" {
  source  = "tfe-online.aws.venting.cloud/vc/workspacer/tfe"
  version = "0.7.0"

  count = var.workspace_count

  organization   = var.organization
  workspace_name = "module-workspacer-with-vcs-${count.index}"
  workspace_desc = "Created by Terraform Workspacer module."
  workspace_tags = ["module-ci", "test", "vcs-driven"]
  force_delete   = true

  working_directory     = "/sample-resources/"
  auto_apply            = true
  file_triggers_enabled = true
  trigger_prefixes      = null # conflicts with `trigger_patterns`
  trigger_patterns      = ["/sample-resources/**/*"]
  queue_all_runs        = true

  vcs_repo = {
    identifier     = "ventingcloud/tfmig-config"
    branch         = "main"
    oauth_token_id = tfe_oauth_client.github.oauth_token_id
    tags_regex     = null # conflicts with `trigger_prefixes` and `trigger_patterns`
  }

}

