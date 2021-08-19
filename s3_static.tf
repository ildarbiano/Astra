#---создание ресурса с приданием ему имени и списка контроля доступа - acl
resource "aws_s3_bucket" "static" {
  bucket = var.bucket_name
  acl    = "public-read"
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [{
      "Sid": "PublicReadForGetBucketObjects",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.bucket_name}/*"
    }]
}
EOF

/*
provisioner
*/

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

#---политикa сегмента, которая делает его содержимое общедоступным
resource "aws_s3_bucket_public_access_block" "static_web" {
  bucket = aws_s3_bucket.static.id
#  block_public_acls   = true         #--Defaults to =false - Block all public access -Off
#  block_public_policy = true         #--Defaults to =false - Block all public access -Off
#---то есть не прописывая эти блоки, откроется полный доступ а s3 bucket
}
/*
#---Terraform Configuration Files
resource "aws_s3_bucket_object" "uploading" {
  bucket = var.bucket_name
#  bucket = aws_s3_bucket.static.id = var.bucket_name
  key    = "upload_html"
#  source = "goods.html" 
  source = "templates_html"
  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  #etag = filemd5("templates")
}
*/
/* Error: Error putting object in S3 bucket (teraform123456): SerializationError: 
|faile to determine start of request body caused by: seek templates: The handle is invalid.

 The system cannot find the file specified.
*/

resource "null_resource" "remove_and_upload_to_s3" {
  provisioner "local-exec" {
    command = "aws s3 sync templates_html s3://${aws_s3_bucket.static.id}"
  }
}