resource "aws_iam_role" "lambda" {
  name = "${var.function_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "basic_execution" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "vpc_access" {
  count      = var.vpc_config != null ? 1 : 0
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "extra" {
  for_each   = toset(var.iam_policy_arns)
  role       = aws_iam_role.lambda.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "inline" {
  count  = var.inline_policy_json != "" ? 1 : 0
  name   = "${var.function_name}-inline-policy"
  role   = aws_iam_role.lambda.id
  policy = var.inline_policy_json
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

resource "aws_security_group" "lambda" {
  count       = var.vpc_config != null ? 1 : 0
  name        = "${var.function_name}-lambda-sg"
  description = "Security group for Lambda ${var.function_name}"
  vpc_id      = var.vpc_config.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = merge(var.tags, { Name = "${var.function_name}-lambda-sg" })
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  description   = var.description
  role          = aws_iam_role.lambda.arn
  handler       = var.handler
  runtime       = var.runtime
  timeout       = var.timeout
  memory_size   = var.memory_size

  filename         = var.filename != "" ? var.filename : null
  s3_bucket        = var.s3_bucket != "" ? var.s3_bucket : null
  s3_key           = var.s3_key != "" ? var.s3_key : null
  source_code_hash = var.source_code_hash != "" ? var.source_code_hash : null

  environment {
    variables = var.environment_variables
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      subnet_ids         = vpc_config.value.subnet_ids
      security_group_ids = concat([aws_security_group.lambda[0].id], lookup(vpc_config.value, "additional_security_group_ids", []))
    }
  }

  dynamic "tracing_config" {
    for_each = var.enable_xray ? [1] : []
    content {
      mode = "Active"
    }
  }

  reserved_concurrent_executions = var.reserved_concurrent_executions

  tags       = merge(var.tags, { Name = var.function_name })
  depends_on = [aws_cloudwatch_log_group.this]
}

resource "aws_lambda_alias" "live" {
  count            = var.create_alias ? 1 : 0
  name             = "live"
  description      = "Live alias for ${var.function_name}"
  function_name    = aws_lambda_function.this.function_name
  function_version = "$LATEST"
}

resource "aws_lambda_permission" "allow_apigw" {
  count         = var.api_gateway_source_arn != "" ? 1 : 0
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = var.api_gateway_source_arn
}
