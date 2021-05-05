terraform {
  backend "s3" {
    bucket = "terraform_backup_state"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
}
