variable "instance_name" {
    default = "Jenkins Server"  # Names of the instance
}

variable "key_name" {
  default = "terra"                  # Names of key in aws
}
variable "private_key" {
  default = "."      # file path of private pem key
}

variable "access_key" {
  default = "AKIASOGXGXHRIBCUOK77"                # aws access key
}

variable "secret_key" {
  default = "8lP8eGjljVLCZ+DFEHMVXa7jX1LYLoHWU29y9J+Y"         # aws secret key
}

