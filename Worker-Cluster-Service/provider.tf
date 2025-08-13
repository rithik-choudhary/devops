provider "aws" {
  region = var.region
  # Credentials will be provided via environment variables in GitHub Actions
  # AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
}

# provider "aws" {
#   region     = "ap-xx-1"
#   access_key = "xxxx"
#   secret_key = "xxx/xx+xx"
# }
