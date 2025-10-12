# Terraform

## Setup

1. secret.auto.tfvars.exampleをコピーしてsecret.auto.tfvarsを作成
```bash
cd terraform/environment/development
cp secret.auto.tfvars.example secret.auto.tfvars
# secret.auto.tfvarsを編集して実際の値を設定
```

2. Terraform実行
```bash
terraform plan
terraform apply
```

## ファイル構成

- `terraform.tfvars` - 非機密情報（ドメイン名など）※コミット対象
- `secret.auto.tfvars` - 機密情報（API Key、パスワードなど）※gitignore（*.tfvarsルールで自動除外）
- `secret.auto.tfvars.example` - secret.auto.tfvarsのテンプレート
