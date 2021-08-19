#--AWS Credentials
variable "MyAWSregion" {type = string}
variable "accountId" {type = string}
#--Names of AWS Resources
variable "bucket_name" {type = string}
variable "lambda_function_name" {type = string}
variable "lambda_function_iam" {type = string}
variable "api_for_lambda_terraform" {type = string}