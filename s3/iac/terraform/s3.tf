# adding a random id suffix so no name collisions with existing buckets.

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "my-s3-bucket-resource-name" {
  bucket = "my-tf-test-bucket-${random_id.suffix.hex}"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}