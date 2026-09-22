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

.PHONY: test
test:
	xcodebuild test \
		-project Reaction.xcodeproj \
		-scheme Development \
		-destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
		-onlyUsePackageVersionsFromResolvedFile \
		-skipPackagePluginValidation \
		-skipMacroValidation \
		CODE_SIGNING_ALLOWED=NO
