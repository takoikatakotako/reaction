import SwiftUI
import StoreKit

/// 設定 > 有料プラン > 解約方法
///
/// アプリ内（サブスクリプションの管理画面）と、iPhone の「設定」アプリからの解約手順を案内する。
/// 「設定」アプリのサブスクリプション画面を直接開く公開 API はないため、そちらは手順の文章だけにしている。
struct CancelGuideView: View {
    /// 管理シートを閉じたとき。解約直後は CustomerInfo のキャッシュが古いので、親画面で最新を取り直す
    let onManageSubscriptionsDismissed: () -> Void

    @State private var showingManageSubscriptions = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                VStack(alignment: .leading, spacing: 12) {
                    heading(String(localized: "cancel-guide-in-app"))
                    bodyText(String(localized: "cancel-guide-in-app-steps"))
                    Button {
                        showingManageSubscriptions = true
                    } label: {
                        Text(String(localized: "premium-plan-manage"))
                            .font(.system(size: 15, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(.bordered)
                    .padding(.top, 4)
                }

                VStack(alignment: .leading, spacing: 12) {
                    heading(String(localized: "cancel-guide-settings"))
                    bodyText(String(localized: "cancel-guide-settings-steps"))
                    Text(String(localized: "cancel-guide-settings-footer"))
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 12) {
                    heading(String(localized: "cancel-guide-notes"))
                    bodyText(String(localized: "cancel-guide-notes-body"))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .manageSubscriptionsSheet(isPresented: $showingManageSubscriptions)
        .onChange(of: showingManageSubscriptions) { _, isShowing in
            if !isShowing {
                onManageSubscriptionsDismissed()
            }
        }
        .navigationTitle(String(localized: "premium-plan-how-to-cancel"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private func heading(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 17, weight: .bold))
            .foregroundStyle(Color(.appMainText))
    }

    private func bodyText(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 15))
            .lineSpacing(4)
            .foregroundStyle(Color(.appMainText))
            .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    NavigationStack {
        CancelGuideView(onManageSubscriptionsDismissed: {})
    }
}
