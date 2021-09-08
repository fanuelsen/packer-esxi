locals {
  esxi_password   = "password!"
  esxi_username   = "root"
  timestamp       = regex_replace(timestamp(), "[- TZ:]", "")
  vm_name         = "alpine-3-14-${local.timestamp}"
}

variable "esxi_host" {
  type    = string
  default = "0.0.0.0"
}

variable "network_name" {
  type    = string
  default = "VM Network"
}

variable "remote_datastore" {
  type    = string
  default = "vms"
}

variable "ssh_username" {
  type    = string
  default = "alpine"
}

variable "ssh_password" {
  type    = string
  default = "alpine"
}

variable "vm_cpu_num" {
  type    = string
  default = "1"
}

variable "vm_disk_additional_size" {
  type    = string
  default = "122880"
}

variable "vm_disk_size" {
  type    = string
  default = "20480"
}

variable "vm_mem_size" {
  type    = string
  default = "1024"
}
