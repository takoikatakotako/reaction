# GitHub Provider
resource "aws_iam_openid_connect_provider" "github_actions" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  # AWS は token.actions.githubusercontent.com のような既知の IdP に対しては、
  # ここに登録したサムプリントではなく AWS 自身が保持する信頼済み CA で TLS 検証を行うため、
  # この値は実質使われない。一方 data.tls_certificate は GitHub の証明書チェーンを
  # 毎回ライブ取得するので、GitHub が証明書をローテートするたびに plan に差分が出てしまう。
  # 作成時のみ値を入れ、以降の変更は無視する。
  thumbprint_list = [data.tls_certificate.github_actions.certificates[0].sha1_fingerprint]

  lifecycle {
    ignore_changes = [thumbprint_list]
  }
}

# see: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
# see: https://github.com/aws-actions/configure-aws-credentials/issues/357#issuecomment-1011642085
data "tls_certificate" "github_actions" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}
