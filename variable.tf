//vpc variable
variable "vpc_cidr" {
  type        = string
  description = "enter vpc cidr value"
  default     = "172.20.0.0/16"
}
//public subnet variable
variable "public_subnet_cidr" {
  type        = list(string)
  description = "enter public subnet cidr value"
  default     = ["172.20.10.0/24", "172.20.11.0/24"]
}
//private subnet variable
variable "private_subnet_cidr" {
  type        = list(string)
  description = "enter private subnet cidr value"
  default     = ["172.20.20.0/24", "172.20.21.0/24"]
}