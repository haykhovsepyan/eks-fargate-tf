module "api-ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "ecr-task"


  repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
  create_lifecycle_policy           = false
  #  repository_image_tag_mutability   = "MUTABLE"
  #   repository_lifecycle_policy = jsonencode({
  #     rules = [
  #       {
  #         rulePriority = 1,
  #         description  = "Keep last 50 images",
  #         selection = {
  #           tagStatus     = "tagged",
  #           tagPrefixList = ["v"],
  #           countType     = "imageCountMoreThan",
  #           countNumber   = 50
  #         },
  #         action = {
  #           type = "expire"
  #         }
  #       }
  #     ]
  #   })

  repository_force_delete = true

}

data "aws_caller_identity" "current" {}
