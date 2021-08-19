#---1) Configurate IAM-Policy for Lambda-function
resource "aws_iam_role" "iam_for_lambda" {
  name                = var.lambda_function_iam
  assume_role_policy  = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
        }
      }]
  })
}


resource "aws_lambda_function" "invoke_lambda" {
  function_name = var.lambda_function_name

#--see https://github.com/hashicorp/terraform-provider-aws/blob/main/examples/lambda/main.tf
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256    
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "put_item.lambda_handler"              
  runtime       = "python3.8"
  

  environment {
    variables   = {
      foo = "bar"
    }
  }
}


#--- Add Inline policy
resource "aws_iam_role_policy" "inline_policy" {
  name    = "policy_for_DynamoDB"
  role    = aws_iam_role.iam_for_lambda.id
  policy  = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "dynamodb:PutItem",
                "dynamodb:DeleteItem",
                "dynamodb:GetItem",
                "dynamodb:Scan",
                "dynamodb:Query",
                "dynamodb:UpdateItem"
              ],
            "Resource": "arn:aws:dynamodb:${var.MyAWSregion}:${var.accountId}:table/Library"
      }]
  })
}


resource "aws_lambda_permission" "api_permission" {
  statement_id  = "AllowMyDemoAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

# The /*/*/* part allows invocation from any stage, method and resource path
# within API Gateway REST API.
#  source_arn = "${aws_api_gateway_rest_api.MyDemoAPI.execution_arn}/*/*/*"

   # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.MyAWSregion}:${var.accountId}:${aws_api_gateway_rest_api.MyDemoAPI.id}/*/${aws_api_gateway_method.MyDemoMethod.http_method}${aws_api_gateway_resource.MyDemoResource.path}"
}