variable "vultr_api_key" {
  type = string
  nullable = false
}

variable "ssh_public_key" {
  type = string
  nullable = false
}

variable "ssh_private_key_path" {
  type = string
  nullable = false
}

variable "username" {
  type = string
  nullable = false
}
