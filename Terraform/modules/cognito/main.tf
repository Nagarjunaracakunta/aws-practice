resource "aws_cognito_user_pool" "this" {
  name = var.user_pool_name

  username_attributes      = var.username_attributes
  auto_verified_attributes = var.auto_verified_attributes

  password_policy {
    minimum_length                   = var.password_minimum_length
    require_lowercase                = var.password_require_lowercase
    require_numbers                  = var.password_require_numbers
    require_symbols                  = var.password_require_symbols
    require_uppercase                = var.password_require_uppercase
    temporary_password_validity_days = var.temporary_password_validity_days
  }

  mfa_configuration = var.mfa_configuration

  dynamic "software_token_mfa_configuration" {
    for_each = var.mfa_configuration != "OFF" ? [1] : []
    content {
      enabled = true
    }
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  email_configuration {
    email_sending_account = var.ses_email_arn != "" ? "DEVELOPER" : "COGNITO_DEFAULT"
    from_email_address    = var.ses_from_email != "" ? var.ses_from_email : null
    source_arn            = var.ses_email_arn != "" ? var.ses_email_arn : null
  }

  dynamic "schema" {
    for_each = var.schema_attributes
    content {
      name                     = schema.value.name
      attribute_data_type      = schema.value.attribute_data_type
      required                 = lookup(schema.value, "required", false)
      mutable                  = lookup(schema.value, "mutable", true)
      developer_only_attribute = lookup(schema.value, "developer_only_attribute", false)

      dynamic "string_attribute_constraints" {
        for_each = schema.value.attribute_data_type == "String" ? [1] : []
        content {
          min_length = lookup(schema.value, "min_length", "0")
          max_length = lookup(schema.value, "max_length", "2048")
        }
      }
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = var.allow_admin_create_user_only
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = var.verification_email_subject
    email_message        = var.verification_email_message
  }

  tags = merge(var.tags, { Name = var.user_pool_name })
}

resource "aws_cognito_user_pool_client" "this" {
  for_each = { for c in var.app_clients : c.name => c }

  name         = each.value.name
  user_pool_id = aws_cognito_user_pool.this.id

  generate_secret                      = lookup(each.value, "generate_secret", false)
  explicit_auth_flows                  = lookup(each.value, "explicit_auth_flows", ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"])
  supported_identity_providers         = lookup(each.value, "supported_identity_providers", ["COGNITO"])
  callback_urls                        = lookup(each.value, "callback_urls", [])
  logout_urls                          = lookup(each.value, "logout_urls", [])
  allowed_oauth_flows                  = lookup(each.value, "allowed_oauth_flows", [])
  allowed_oauth_scopes                 = lookup(each.value, "allowed_oauth_scopes", [])
  allowed_oauth_flows_user_pool_client = length(lookup(each.value, "allowed_oauth_flows", [])) > 0

  access_token_validity  = lookup(each.value, "access_token_validity", 1)
  id_token_validity      = lookup(each.value, "id_token_validity", 1)
  refresh_token_validity = lookup(each.value, "refresh_token_validity", 30)

  token_validity_units {
    access_token  = "hours"
    id_token      = "hours"
    refresh_token = "days"
  }

  prevent_user_existence_errors = "ENABLED"
}

resource "aws_cognito_user_pool_domain" "this" {
  count        = var.domain != "" ? 1 : 0
  domain       = var.domain
  user_pool_id = aws_cognito_user_pool.this.id
}

resource "aws_cognito_identity_pool" "this" {
  count                            = var.create_identity_pool ? 1 : 0
  identity_pool_name               = "${var.user_pool_name}-identity-pool"
  allow_unauthenticated_identities = var.allow_unauthenticated_identities

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.this[var.app_clients[0].name].id
    provider_name           = aws_cognito_user_pool.this.endpoint
    server_side_token_check = false
  }

  tags = var.tags
}

resource "aws_iam_role" "authenticated" {
  count = var.create_identity_pool ? 1 : 0
  name  = "${var.user_pool_name}-authenticated-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = "cognito-identity.amazonaws.com"
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "cognito-identity.amazonaws.com:aud" = aws_cognito_identity_pool.this[0].id
        }
        "ForAnyValue:StringLike" = {
          "cognito-identity.amazonaws.com:amr" = "authenticated"
        }
      }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "authenticated" {
  count = var.create_identity_pool ? 1 : 0
  name  = "${var.user_pool_name}-authenticated-policy"
  role  = aws_iam_role.authenticated[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["mobileanalytics:PutEvents", "cognito-sync:*", "cognito-identity:*"]
      Resource = "*"
    }]
  })
}

resource "aws_cognito_identity_pool_roles_attachment" "this" {
  count            = var.create_identity_pool ? 1 : 0
  identity_pool_id = aws_cognito_identity_pool.this[0].id

  roles = {
    authenticated = aws_iam_role.authenticated[0].arn
  }
}
