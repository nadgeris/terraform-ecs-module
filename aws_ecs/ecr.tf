
resource "aws_ecr_repository" "ecr" {
    count = length(var.ecr)
    name = element(var.ecr,count.index)
    image_tag_mutability = "MUTABLE"
    tags = {
        Name = element(var.ecr,count.index)
        Terraform   = "true"
        Environment = "qe"
    }
}

output "ecr_repo_url" {
    value = aws_ecr_repository.ecr.*.repository_url
    }
