terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.7.5"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

resource "github_repository" "repo" {
  name        = var.repo_name
  description = var.repo_description
  visibility  = var.repo_visibility
  auto_init   = true
}

resource "github_branch_protection" "main_branch" {
  repository_id = github_repository.repo.node_id
  pattern       = "main"

  required_status_checks {
    strict   = true
    contexts = []
  }
}

data "github_team" "team" {
  count = var.repo_team != "" ? 1 : 0
  slug  = var.repo_team
}

resource "github_team_repository" "team_access" {
  count      = var.repo_team != "" ? 1 : 0
  team_id    = data.github_team.team[0].id
  repository = github_repository.repo.name
  permission = "maintain"
}

locals {
  codeowners_usernames = join(" ", [for u in data.github_team.team.*.members : "@${u}"])
  codeowners_content   = <<EOT
* ${local.codeowners_usernames}
EOT
}

resource "github_repository_file" "codeowners" {
  count               = length(data.github_team.team.*.members) > 0 ? 1 : 0
  repository          = github_repository.repo.name
  branch              = "main"
  file                = ".github/CODEOWNERS"
  content             = local.codeowners_content
  commit_message      = "Add CODEOWNERS file"
  overwrite_on_create = true
}
