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
# TestFlight は同じ (MARKETING_VERSION, CFBundleVersion) の再アップロードを
# 受け付けない。コミット数 * 100 + RETRY で採番する。
#
# コミット数そのものを使うと、同じコミットを手で +1 して配信したあと、
# 次のコミットで自動採番に戻ったときに同じ番号になってしまう
#   例) 628 で配信 -> 同じコミットを 629 で配信 -> 次のコミットも 629
# 下 2 桁を再配信用に空けておけば、RETRY を使っても次のコミットの
# 番号 (n+1)*100 を超えないので、自動採番に戻しても衝突しない。
#
#   make archive            # 62700
#   make archive RETRY=1    # 62701（同じコミットで作り直すとき）
RETRY ?= 0
BUILD_NUMBER ?= $(shell echo $$(( $$(git rev-list --count HEAD) * 100 + $(RETRY) )))

# 浅いクローンだとコミット数が実際より小さくなり、番号が巻き戻る。
# CI では actions/checkout に fetch-depth: 0 を指定すること。
.PHONY: check-not-shallow
check-not-shallow:
	@if [ "$$(git rev-parse --is-shallow-repository)" = "true" ]; then \
		echo "error: 浅いクローンではビルド番号を採番できません" >&2; \
		echo "       git fetch --unshallow するか fetch-depth: 0 を指定してください" >&2; \
		exit 1; \
	fi

ARCHIVE_PATH = build/Reaction.xcarchive
EXPORT_PATH  = build/export

# 配布用の署名は Xcode に任せる。
#
# -allowProvisioningUpdates は Apple Developer との通信を許可するフラグで、
# 自動署名ターゲット（このプロジェクトは CODE_SIGN_STYLE: Automatic）では
# プロファイル・App ID・証明書の作成と更新を行う。証明書が新規に発行され
# ないことは保証されない。
.PHONY: archive
archive: check-not-shallow generate
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
