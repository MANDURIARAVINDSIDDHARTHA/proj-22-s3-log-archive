variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "bucket_name" {
  type    = string
  default = "aravind-proj22-log-archive-590507089733"
}

variable "expiration_days" {
  type    = number
  default = 30
}
