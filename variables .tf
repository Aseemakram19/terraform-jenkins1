variable "instance_name" {
    default = "Jenkins Server"  # Names of the instance
}

variable "key_name" {
  default = "jenkins tf key"                  # Names of key in aws
}
variable "private_key" {
  default = "."      # file path of private pem key
}

variable "access_key" {
  default = "AHYoOLGiLW+oRvvG3c7nqHRgohyRY9WzTpm91SkP"                # aws access key
}

variable "secret_key" {
  default = "AHYoOLGiLW+oRvvG3c7nqHRgohyRY9WzTpm91SkP"         # aws secret key
}

