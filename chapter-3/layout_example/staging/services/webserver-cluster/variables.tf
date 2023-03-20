variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}

variable "alb_http_port" {
  description = "The port the ALB will listen for HTTP requests on"
  type = number
  default = 80
}
