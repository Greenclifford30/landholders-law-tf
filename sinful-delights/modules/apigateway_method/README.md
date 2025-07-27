
# API Gateway Method Module

This Terraform module provisions a single AWS API Gateway method (e.g., GET, POST) and links it to a Lambda function using `AWS_PROXY` integration. It also optionally configures an `OPTIONS` method to support CORS for frontend web applications.

---

## 📦 Features

- Connects an HTTP method (GET, POST, etc.) to a Lambda function
- Supports optional **custom authorizers**
- Passes URI parameters to Lambda (e.g. `/resource/{id}`)
- Optionally provisions an `OPTIONS` method for CORS (default: enabled)
- Creates `lambda:InvokeFunction` permission for API Gateway
- Safe for reuse across multiple routes/resources

---

## 🚀 Usage

```hcl
module "get_order" {
  source                     = "./modules/apigateway_method"
  api_id                     = aws_api_gateway_rest_api.main.id
  resource_id                = aws_api_gateway_resource.order.id
  http_method                = "GET"
  lambda_arn                 = module.get_order_lambda.lambda_function_arn
  lambda_invoke_arn          = module.get_order_lambda.lambda_invoke_arn
  apig_gateway_source_arn    = aws_api_gateway_rest_api.main.execution_arn
  create_options             = true
}
```

---

## 🔧 Variables

| Name                      | Type     | Default | Description |
|---------------------------|----------|---------|-------------|
| `api_id`                  | string   | —       | ID of the API Gateway REST API |
| `resource_id`             | string   | —       | ID of the API Gateway resource path |
| `http_method`             | string   | —       | HTTP method (GET, POST, etc.) |
| `lambda_arn`              | string   | —       | ARN of the Lambda function |
| `lambda_invoke_arn`       | string   | —       | `invoke_arn` of the Lambda function |
| `apig_gateway_source_arn` | string   | —       | API Gateway source ARN for permissions |
| `authorizer_id`           | string   | null    | Optional: ID of a custom Lambda authorizer |
| `expect_uri_parameter`    | bool     | false   | Whether to pass a URI param to Lambda |
| `uri_param`               | string   | ""      | Name of the URI param (e.g., `id` for `/resource/{id}`) |
| `lambda_invoke_permission`| bool     | true    | Whether to create lambda invoke permission |
| `create_options`          | bool     | true    | Whether to create `OPTIONS` method for CORS |

---

## 🛑 Notes

- When using `expect_uri_parameter`, make sure the resource path contains `{var.uri_param}`.
- CORS headers are added using a MOCK integration for OPTIONS.

---

## 📁 Outputs

This module does not currently export any outputs. If needed, feel free to extend it!

---

## 🧪 Example with URI param

```hcl
module "get_item" {
  source                  = "./modules/apigateway_method"
  api_id                  = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.item_id.id
  http_method             = "GET"
  lambda_arn              = module.get_item_lambda.lambda_function_arn
  lambda_invoke_arn       = module.get_item_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.main.execution_arn

  expect_uri_parameter    = true
  uri_param               = "itemId"
}
```
