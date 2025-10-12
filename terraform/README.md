# Terraform

## Setup

1. credentials.tfvars.exampleをコピーしてcredentials.tfvarsを作成
```bash
cd terraform/environment/development
cp credentials.tfvars.example credentials.tfvars
# credentials.tfvarsを編集して実際の値を設定
```

2. Terraform実行時は-var-fileでcredentials.tfvarsを指定
```bash
terraform plan -var-file="terraform.tfvars" -var-file="credentials.tfvars"
terraform apply -var-file="terraform.tfvars" -var-file="credentials.tfvars"
```

## ファイル構成

- `terraform.tfvars` - 非機密情報（ドメイン名など）※コミット対象
- `credentials.tfvars` - 機密情報（API Key、パスワードなど）※gitignore
- `credentials.tfvars.example` - credentials.tfvarsのテンプレート
