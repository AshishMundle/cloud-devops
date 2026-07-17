resource "aws_iam_role" "lambda-role" {
  name               = "lambda-role-Resize-Image2"
  assume_role_policy = file("${path.module}/lambda_role.json")
}