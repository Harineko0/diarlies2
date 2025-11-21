variable "project_id" {
  description = "GCP project id (set via TF_VAR_project_id or a tfvars file)."
  type        = string
}

variable "region" {
  description = "Default GCP region."
  type        = string
  default     = "us-central1"
}

variable "app_name" {
  description = "Prefix for shared resources."
  type        = string
  default     = "diarlies"
}
