# 初期化コンテナ（テーブル・バケット作成）の完了まで待ってから戻る。
# --wait は healthcheck を持つサービスの healthy と、
# 一度きりのコンテナの正常終了を待つ。
.PHONY: setup
setup:
		docker compose up -d --wait

.PHONY: down
down:
		docker compose down

