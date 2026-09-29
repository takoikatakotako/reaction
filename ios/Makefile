RESOLVED_DIR = Reaction.xcodeproj/project.xcworkspace/xcshareddata/swiftpm

# xcodegen でプロジェクトを生成し、バージョン管理している Package.resolved を配置する
.PHONY: generate
generate:
	mint run xcodegen xcodegen generate
	mkdir -p $(RESOLVED_DIR)
	cp Package.resolved $(RESOLVED_DIR)/Package.resolved

# Xcode 側で依存を更新したあと、その結果をバージョン管理側に書き戻す
.PHONY: save-resolved
save-resolved:
	cp $(RESOLVED_DIR)/Package.resolved Package.resolved

.PHONY: lint
lint:
	mint run swiftlint swiftlint --strict

# シミュレータは名前ではなく UDID で指定する。同じ名前の端末が複数あると
# xcodebuild は解決できず、macOS にフォールバックして
# 「My Mac's macOS platform doesn't match」で失敗する。Xcode を更新すると
# 旧バージョンの端末が残って名前が重複しやすい。
#
# 自動選択は test のレシピの中だけで行う。Makefile のトップレベルで
# $(shell ...) を使うと読み込み時に評価され、lint や generate でも
# simctl が起動してしまう。
#
# SIMULATOR_UDID を渡せばそちらが優先される。
SIMULATOR_UDID ?=

.PHONY: test
test:
	@set -e; \
	udid="$(SIMULATOR_UDID)"; \
	if [ -z "$$udid" ]; then \
		udid=$$(xcrun simctl list devices available --json \
			| jq -r '[.devices[][] | select(.name | startswith("iPhone"))] | last | .udid'); \
	fi; \
	if [ -z "$$udid" ] || [ "$$udid" = "null" ]; then \
		echo "error: 利用可能な iPhone シミュレータが見つかりません" >&2; \
		xcrun simctl list devices available; \
		exit 1; \
	fi; \
	echo "使用するシミュレータ: $$udid"; \
	xcodebuild test \
		-project Reaction.xcodeproj \
		-scheme Development \
		-destination "id=$$udid" \
		-onlyUsePackageVersionsFromResolvedFile \
		-skipPackagePluginValidation \
		-skipMacroValidation \
		CODE_SIGNING_ALLOWED=NO
