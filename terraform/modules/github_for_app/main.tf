# App CI Role
resource "aws_iam_role" "app_ci_role" {
  name               = "management-ci-role"
  assume_role_policy = data.aws_iam_policy_document.app_ci_role_assume_policy_document.json
}

data "aws_iam_policy_document" "app_ci_role_assume_policy_document" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "AWS"
      identifiers = [
        var.github_action_role_arn
      ]
    }
  }
}

resource "aws_iam_policy" "app_ci_role_policy" {
  name   = "app-ci-role-policy"
  policy = data.aws_iam_policy_document.app_ci_role_policy_document.json
}

data "aws_iam_policy_document" "app_ci_role_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:*",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "app_ci_role_policy_attachment" {
  role       = aws_iam_role.app_ci_role.name
  policy_arn = aws_iam_policy.app_ci_role_policy.arn
}
