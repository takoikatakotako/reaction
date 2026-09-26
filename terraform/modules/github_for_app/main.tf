# App CI Role
resource "aws_iam_role" "app_ci_role" {
  name               = "reaction-ci-role"
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
  name   = "reaction-ci-role-policy"
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

  statement {
    effect = "Allow"
    actions = [
      "cloudfront:CreateInvalidation",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "lambda:UpdateFunctionCode",
      "lambda:GetFunction",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:Scan",
      "dynamodb:BatchWriteItem",
      "dynamodb:DescribeTable",
    ]
    resources = ["*"]
  }

  # モバイルのビルドに必要な設定ファイル・署名鍵の取得
  # （scripts/firebase-config.sh, scripts/android-signing.sh）
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
    ]
    resources = [
      "arn:aws:ssm:*:*:parameter/reaction/*/firebase/*",
      "arn:aws:ssm:*:*:parameter/reaction/*/android/*",
    ]
  }

  # SecureString の復号。SSM 経由の呼び出しに限定する
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["ssm.ap-northeast-1.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "app_ci_role_policy_attachment" {
  role       = aws_iam_role.app_ci_role.name
  policy_arn = aws_iam_policy.app_ci_role_policy.arn
}

resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.app_ci_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
