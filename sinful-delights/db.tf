############################################################
# DynamoDB – single table holding menus, orders, subscriptions, etc.
############################################################

resource "aws_dynamodb_table" "sinful_delights" {
  name         = "${var.app}"
  billing_mode = "PAY_PER_REQUEST"   # On‑demand capacity – perfect for bursty meal‑time traffic

  hash_key  = "PK"  # partition key
  range_key = "SK"  # sort key

  attribute { 
    name = "PK"  
    type = "S" 
}
  attribute { 
    name = "SK"  
    type = "S" 
}

  # Attributes required by GSIs ↓
  attribute { 
    name = "entityType" 
    type = "S" 
}
  attribute { 
    name = "menuDate"
    type = "S" 
 }
  attribute { 
    name = "itemId"     
    type = "S" 
    }
  attribute { 
    name = "status"     
    type = "S" 
    }
  attribute { 
    name = "createdAt"  
    type = "S" 
    }

  ##########################################################
  # Global Secondary Indexes – align with access patterns
  ##########################################################

  # GSI1 – List all menus (PK=entityType, SK=menuDate)
  global_secondary_index {
    name               = "GSI1"
    hash_key           = "entityType"
    range_key          = "menuDate"
    projection_type    = "ALL"    # full item in index – simplifies queries
  }

  # GSI2 – Fetch today’s menu (PK=menuDate, SK=itemId)
  global_secondary_index {
    name               = "GSI2"
    hash_key           = "menuDate"
    range_key          = "itemId"
    projection_type    = "ALL"
  }

  # GSI3 – Dashboard views by status (PK=status, SK=createdAt)
  global_secondary_index {
    name               = "GSI3"
    hash_key           = "status"
    range_key          = "createdAt"
    projection_type    = "ALL"
  }

  ##########################################################
  # Additional table features
  ##########################################################

  ttl {
    attribute_name = "ttl"   # epoch‑seconds timestamp for auto‑expiry (e.g., soft‑deleted records)
    enabled        = true
  }

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"  # Full change event – useful for DMS → Aurora analytics pipeline

  point_in_time_recovery {
    enabled = true  # PITR up to 35 days – safety net for accidental deletes
  }
}