variable "hcloud_token" {
  description = "Hetzner token"
}
variable "personal_ips" {
  type        = list(string)
  description = "List your external IP to access instance via SSH"
  default     = ["0.0.0.0/0"]
}

variable "project_name" {
  type        = string
  description = "Project name"
  default     = "maklai"
}