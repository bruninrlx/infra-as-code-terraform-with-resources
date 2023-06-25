resource "aws_ecr_repository" "auth" {
  name                 = "auth"  
  image_tag_mutability = "MUTABLE" 

  image_scanning_configuration {
    scan_on_push = true  
  }
}

resource "aws_ecr_repository" "catalog" {
  name                 = "catalog"
  image_tag_mutability = "MUTABLE" 

  image_scanning_configuration {
    scan_on_push = true  
  }
}

resource "aws_ecr_repository" "checkout" {
  name                 = "checkout"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true  
  }
}

resource "aws_ecr_repository" "freight" {
  name                 = "freight"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true  
  }
}

resource "aws_ecr_repository" "stock" {
  name                 = "stock"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true  
  }
}