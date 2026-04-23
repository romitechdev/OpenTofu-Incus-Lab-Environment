variable "incus_token" {
  type      = string
  sensitive = true
}

variable "vm_list" {
  type = map(object({
    cpu       = number
    memory    = string
    disk      = string
    user_data = string
    station   = optional(string)
    pool      = optional(string, "hdd1")
  }))
}
