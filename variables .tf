variable "instance_name" {
    default = "Jenkins Server"  # Names of the instance
}

variable "key_name" {
  default = "terra"                  # Names of key in aws
}
variable "private_key" {
  default = "terra.pem"      # file path of private pem key
}

variable "access_key" {
  default = "insert"                # aws access key
}

variable "secret_key" {
  default = "insert"         # aws secret key
}

