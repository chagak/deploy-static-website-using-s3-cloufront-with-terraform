resource "aws_s3_bucket" "example" {
  bucket = "chaganote-static-add-folder"
  force_destroy = true
}

# Upload files to S3 using local-exec
# resource "null_resource" "upload_docker_folder" {
#   provisioner "local-exec" {
#     command = "aws s3 sync ./honey-static-webapp s3://${aws_s3_bucket.example.bucket} --acl private"
#   }

#   depends_on = [aws_s3_bucket.example]
# }
## Let try again
