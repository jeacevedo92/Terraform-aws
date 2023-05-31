
variable "ami_id" {
  type        = string
  default     = ""
  description = "description"
}

variable "PRIVATE_KEY_PATH" {
  default = "aws-key"
}
variable "PUBLIC_KEY_PATH" {
  default = "aws-key.pub"
}
variable "EC2_USER" {
  default = "ubuntu"
}