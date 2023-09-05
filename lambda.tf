module "send_lambda_function" {
  source = "modules/terraform-aws-modules"
  #version = "3.3.1"

  function_name = module.this.id
  description   = "forward mail via ses"
  runtime          = var.lambda_runtime
  handler          = "index.handler"

  source_path = [ format("%s/lambda", abspath(path.module)) ]

  publish = true
  tracing_mode = var.tracing_config_mode
  timeout = 15

  environment_variables = {
    EMAIL_FROM        = var.relay_email
    EMAIL_BUCKET_NAME = aws_s3_bucket.default.bucket
    EMAIL_BUCKET_PATH = ""
    EMAIL_MAPPING     = jsonencode(var.forward_emails)
  }

  attach_policy_json = true
  policy_json = data.aws_iam_policy_document.lambda.json

  assume_role_policy_statements = {
    assume = {
      effect  = "Allow",
      actions = ["sts:AssumeRole"],
      principals = {
        account_principal = {
          type        = "Service",
          identifiers = ["lambda.amazonaws.com"]
        }
      }
      resources = ["*"]
    }
  }
}

resource "aws_lambda_alias" "default" {
  name             = "default"
  description      = "Use latest version as default"
  function_name  = module.send_lambda_function.lambda_function_name
  function_version = "$LATEST"
}

resource "aws_lambda_permission" "ses" {
  statement_id   = "AllowExecutionFromSES"
  action         = "lambda:InvokeFunction"
  function_name  = module.send_lambda_function.lambda_function_name
  principal      = "ses.amazonaws.com"
  source_account = data.aws_caller_identity.current.account_id
}

data "aws_iam_policy_document" "lambda" {

  statement {
    effect = "Allow"

    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = ["${aws_s3_bucket.default.arn}/*"]
  }
}
