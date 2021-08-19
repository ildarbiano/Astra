###---конфигурация terraform и провайдеров---###

#--создание места хранения backends .tfstate 
terraform {
  backend "s3" {            
    bucket = "astra-simple-web-shop"
    key = "s3.tfstate"
  }
}

provider "aws" {
  profile = "default"
  region  = var.MyAWSregion
}

provider "archive" {}
data "archive_file" "zip" {
  type        = "zip"
  source_file = "put_item.py"
  output_path = "put_item.zip"
}
