variable "namespace" {
  description = "Namespace to deploy workloads and configuration"
  type        = string
  default     = "default"
}

variable "labels" {
  description = "Labels to add to the Drone server deployment"
  type        = map(any)
  default     = {}
}

variable "match_labels" {
  description = "Match labels to add to the Drone server deployment, will be merged with labels"
  type        = map(any)
  default     = {}
}

variable "image_registry" {
  description = "Image registry, e.g. gcr.io, docker.io"
  type        = string
  default     = ""
}

variable "image_repository" {
  description = "Image to start for the server"
  type        = string
  default     = "drone/drone"
}

variable "image_tag" {
  description = "Image tag to for the server"
  type        = string
  default     = "2"
}

variable "drone_admin" {
  description = "User handle of Drone admin user"
  type        = string
}

variable "drone_registration_closed" {
  description = "Close registration in Drone"
  type        = bool
  default     = true
}

variable "drone_host" {
  description = "Drone hostname"
  type        = string
}

variable "drone_proto" {
  description = "Drone protocol"
  type        = string
  default     = "https"
}

variable "drone_gitea_url" {
  description = "Gitea URL"
  type        = string
  default     = ""
}

variable "drone_gitea_client" {
  description = "Gitea client ID"
  type        = string
  default     = ""
}

variable "drone_gitea_secret" {
  description = "Gitea client secret"
  type        = string
  default     = ""
}

variable "drone_database_driver" {
  description = "Drone database driver"
  type        = string
  default     = "postgres"
}

variable "drone_database_datasource" {
  description = "Database URL"
  type        = string
  default     = ""
}

variable "drone_s3_bucket" {
  description = "S3 bucket to store Drone blobs"
  type        = string
  default     = ""
}

variable "drone_s3_endpoint" {
  description = "S3 endpoint for Drone blobs"
  type        = string
  default     = ""
}

variable "drone_s3_path_style" {
  description = "Use path-style for S3 service"
  type        = bool
  default     = false
}

variable "drone_s3_prefix" {
  description = "Subdirectory to store log files"
  type        = string
  default     = ""
}

variable "drone_starlark_enabled" {
  description = "Configure Drone to automatically execute files ending in .star"
  type        = bool
  default     = false
}

variable "drone_user_filter" {
  description = "Comma-separated list of accounts or organizations that will limit registration of users"
  type        = string
  default     = ""
}

variable "drone_webhook_endpoint" {
  description = "Comma-separated list of webhook endpoints, to which global system events are delivered"
  type        = string
  default     = ""
}

variable "drone_webhook_events" {
  description = "Comma-separated list of webhook events"
  type        = string
  default     = ""
}

variable "drone_webhook_secret" {
  description = "Shared secret used to create an http-signature"
  type        = string
  default     = ""
}

variable "drone_webhook_skip_verify" {
  description = "Boolean value disables TLS verification when establishing a connection to the remote webhook address"
  type        = bool
  default     = false
}

variable "drone_s3_access_key" {
  description = "Drone S3"
  type        = string
  default     = ""
}

variable "drone_s3_secret_key" {
  description = "Drone S3"
  type        = string
  default     = ""
}

variable "drone_s3_default_region" {
  description = "Drone S3"
  type        = string
  default     = "us-east-1"
}

variable "drone_s3_region" {
  description = "Drone S3"
  type        = string
  default     = "us-east-1"
}
