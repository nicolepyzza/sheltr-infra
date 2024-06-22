variable "environment" {
  type        = string
  description = "environment of the deployment"
}

variable "bucket_name" {
  type        = string
  description = "bucket for tfstate"
}

variable "key" {
  type        = string
  description = "key of state file"
}