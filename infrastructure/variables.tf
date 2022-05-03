variable "ibmcloud_api_key" {
  type = string
}

variable "resourceGroupName" {
  type = string
  default = "poc"
}

variable "k8sname" {
  type = string
  default = "poc"
}

variable "k8s_version" {
  type = string
  default = "1.23.6"
}

variable "datacenter" {
  type = string
  default = "sjc04"
}

variable "pod_subnet" {
  type = string
  default = "172.30.0.0/16"
}

variable "pool_size" {
  type = number
  default = 1
}

variable "worker_number" {
  type = number
  default = 1
}