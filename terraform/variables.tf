variable "region" {
  type        = string
  description = "AWS EU West Region"
  default     = "eu-west-2"
}

variable "ami_ubuntu" {
  type        = string
  description = "Ubuntu 22.04 Server (eu-west-2)"
  default     = "ami-0a244485e2e4ffd03"
}

variable "ami_rocky" {
  type        = string
  description = "RockyLinux 9.2 (eu-west-2)"
  default     = "ami-062a6fb145cf9876f"
}

variable "instance_type" {
  type        = string
  description = "instance type"
  default     = "t2.micro"
}
