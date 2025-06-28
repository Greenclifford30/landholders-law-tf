variable "function_name" {
  description = "Lambda function name"
  type        = string
}

variable "handler" {
  description = "Handler (e.g., main.handler)"
  type        = string
  default     = "app.handler"
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.13"
}

variable "role_arn" {
  description = "IAM role ARN for the Lambda"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables to pass to Lambda"
  type        = map(string)
  default     = {}
}

variable "timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 10
}

variable "source_path" {
  description = "Relative path to lambda source root"
  type        = string
  default     = "src"
}

variable "filename" {
  description = "Lambda zip file name to be replaced by Git deploy step"
  type        = string
  default     = "bootstrap/lambda_stub.zip"
}