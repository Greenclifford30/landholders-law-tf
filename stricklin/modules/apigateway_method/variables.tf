variable "api_id" {
  description = "The ID of the API Gateway REST API"
  type        = string
}

variable "resource_id" {
  description = "The resource ID within the REST API (e.g., /menus)"
  type        = string
}

variable "http_method" {
  description = "HTTP method (GET, POST, etc.)"
  type        = string
}

variable "lambda_arn" {
  description = "ARN of the Lambda function to integrate"
  type        = string
}

variable "lambda_invoke_permission" {
  description = "Whether to attach invoke permission for the Lambda"
  type        = bool
  default     = true
}

variable "lambda_invoke_arn" {
  type = string
}

variable "authorizer_id" {
  description = "Optional authorizer ID for secured routes"
  type        = string
  default     = null
}

variable "apig_gateway_source_arn" {
  description = "api gateway source arn"
  type = string
}
variable "expect_uri_parameter" {
  type = bool
  default = false
}

variable "uri_param" {
  type = string
  default = ""
}

variable "allowed_origin" {
  description = "Origin allowed for CORS"
  default     = "*"
}

variable "allowed_methods" {
  description = "List of HTTP methods allowed for CORS"
  type        = list(string)
  default     = ["GET", "POST", "OPTIONS", "PUT", "DELETE"]
}

variable "allowed_headers" {
  description = "List of headers allowed for CORS"
  type        = list(string)
  default     = ["Content-Type", "X-Amz-Date", "Authorization", "X-Api-Key"]
}
