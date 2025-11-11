variable "repo_name" {
  type        = string
  description = "The name of the GitHub repository"
}

variable "repo_description" {
  type        = string
  description = "Description of the repository"
  default     = ""
}

variable "repo_visibility" {
  type        = string
  description = "Repository visibility: public or private"
  default     = "public"
}

variable "repo_team" {
  type        = string
  description = "Name of the GitHub team to add as maintainer"
  default     = ""
}

variable "github_token" {
  type        = string
  description = "GitHub Personal Access Token"
  sensitive   = true
}

variable "github_owner" {
  type        = string
  description = "GitHub user or organization name"
}
