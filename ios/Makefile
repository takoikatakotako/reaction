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

# --- TestFlight 配信 ---------------------------------------------------------
# ビルド番号。TestFlight は同じ (MARKETING_VERSION, CFBundleVersion) の
# 再アップロードを受け付けないので、上げ直すときに指定する。
#   make archive BUILD_NUMBER=2
BUILD_NUMBER ?= 1

ARCHIVE_PATH = build/Reaction.xcarchive
EXPORT_PATH  = build/export

# 配布用の署名は Xcode に任せる。このチームは Cloud Managed Distribution
# Certificate を使っており、秘密鍵は Apple 側にある（手元の keychain には
# 無い）。-allowProvisioningUpdates がそれを取ってくる。
.PHONY: archive
archive: generate
	xcodebuild archive \
		-project Reaction.xcodeproj \
		-scheme Production \
		-configuration Release \
		-destination 'generic/platform=iOS' \
		-archivePath $(ARCHIVE_PATH) \
		-onlyUsePackageVersionsFromResolvedFile \
		-skipPackagePluginValidation \
		-skipMacroValidation \
		-allowProvisioningUpdates \
		CURRENT_PROJECT_VERSION=$(BUILD_NUMBER)

.PHONY: export
export:
	xcodebuild -exportArchive \
		-archivePath $(ARCHIVE_PATH) \
		-exportPath $(EXPORT_PATH) \
		-exportOptionsPlist ExportOptions.plist \
		-allowProvisioningUpdates
	@echo
	@echo "できました: ios/$(EXPORT_PATH)/ReactionProduction.ipa"
	@echo "Transporter でアップロードするか、Xcode の Organizer から配信してください。"
