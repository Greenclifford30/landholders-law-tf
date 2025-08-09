resource "aws_dynamodb_table" "menu" {
  name         = "${var.app_upper_camel}Menu"
  billing_mode = "PAY_PER_REQUEST"

  # Primary key: all rows (header + items) live in the same partition (menuId)
  hash_key  = "menuId"
  range_key = "itemId"   # different SK per row (META for header, ITEM#uuid for items)

  attribute { 
    name = "menuId"   
    type = "S" 
  }
  attribute { 
    name = "itemId" 
   type = "S" 
   }
  attribute { 
    name = "menuDate"
    type = "S" 
  } # used for GSI queries (YYYY-MM-DD)

  global_secondary_index {
    name               = "GSI1MenuDate"
    hash_key           = "menuDate"
    range_key          = "itemId"         # lets you get header (META) first, items next
    projection_type    = "ALL"
  }

  point_in_time_recovery { enabled = true }
}


resource "aws_dynamodb_table" "menu_item" {
  name           = "${var.app_upper_camel}MenuItem"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "menuId"
  range_key      = "itemId"

  attribute {
    name = "menuId"
    type = "S"
  }

  attribute {
    name = "itemId"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}

resource "aws_dynamodb_table" "predefined_menu" {
  name           = "${var.app_upper_camel}PredefinedMenu"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "templateId"

  attribute {
    name = "templateId"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}

resource "aws_dynamodb_table" "order" {
  name           = "${var.app_upper_camel}Order"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "orderId"
  range_key      = "userId"

  attribute {
    name = "orderId"
    type = "S"
  }

  attribute {
    name = "userId"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}

resource "aws_dynamodb_table" "subscription" {
  name           = "${var.app_upper_camel}Subscription"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "subscriptionId"
  range_key      = "userId"

  attribute {
    name = "subscriptionId"
    type = "S"
  }

  attribute {
    name = "userId"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}

resource "aws_dynamodb_table" "catering_request" {
  name           = "${var.app_upper_camel}CateringRequest"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "requestId"
  range_key      = "userId"

  attribute {
    name = "requestId"
    type = "S"
  }

  attribute {
    name = "userId"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}
