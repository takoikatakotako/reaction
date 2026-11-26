import SwiftUI
import StoreKit

/// 設定 > 有料プラン
///
/// 有料プランの紹介、現在の状態、登録・復元・サブスクリプション管理への導線、解約方法の案内。
struct PremiumPlanView: View {
    @StateObject var viewState: PremiumPlanViewState

    var body: some View {
        ZStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(String(localized: "premium-plan-title"))
                            .font(.headline)
                        Text(String(localized: "premium-plan-description"))
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)

                    featureRow(String(localized: "premium-plan-feature-all"))
                    featureRow(String(localized: "premium-plan-feature-figures"))
                    featureRow(String(localized: "premium-plan-feature-fullscreen"))
                } header: {
                    Text(String(localized: "premium-plan-features"))
                }

                Section {
                    HStack {
                        CommonText(text: String(localized: "premium-plan-status"), font: Font.system(size: 14))
                        Spacer()
                        Text(viewState.statusText)
                    }
                    if let expirationRow = viewState.expirationRow {
                        HStack {
                            CommonText(text: expirationRow.title, font: Font.system(size: 14))
                            Spacer()
                            Text(expirationRow.date)
                        }
                    }
                } header: {
                    Text(String(localized: "premium-plan-current"))
                } footer: {
                    if viewState.plan == .legacyPurchase {
                        Text(String(localized: "premium-plan-legacy-note"))
                    }
                }

                Section {
                    if viewState.isNotSubscribed {
                        Button(String(localized: "premium-plan-subscribe")) {
                            viewState.showingPaywall = true
                        }
                    }
                    if viewState.isSubscribed {
                        Button(String(localized: "premium-plan-manage")) {
                            viewState.showingManageSubscriptions = true
                        }
                    }
                    Button(String(localized: "premium-plan-restore")) {
                        viewState.restore()
                    }
                }
                .disabled(viewState.isProcessing)

                Section {
                    NavigationLink {
                        CancelGuideView(onManageSubscriptionsDismissed: {
                            viewState.manageSubscriptionsDismissed()
                        })
                    } label: {
                        CommonText(text: String(localized: "premium-plan-how-to-cancel"), font: Font.system(size: 14))
                    }
                }
            }
            .listStyle(.grouped)

            if viewState.isProcessing {
                ProgressView()
                    .scaleEffect(1.5, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .padding(36)
                    .background(Color(.appMainText).opacity(0.5))
                    .cornerRadius(24)
            }
        }
        .onAppear {
            viewState.onAppear()
        }
        .onDisappear {
            viewState.onDisappear()
        }
        .sheet(isPresented: $viewState.showingPaywall, onDismiss: {
            viewState.paywallDismissed()
        }) {
            PremiumPaywallView(onUnlocked: {})
        }
        .manageSubscriptionsSheet(isPresented: $viewState.showingManageSubscriptions)
        .onChange(of: viewState.showingManageSubscriptions) { _, isShowing in
            if !isShowing {
                viewState.manageSubscriptionsDismissed()
            }
        }
        .alert(restoreAlertTitle, isPresented: restoreAlertBinding) {
            Button(String(localized: "common-close"), role: .cancel) {}
        }
        .navigationTitle(String(localized: "setting-premium-plan"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private func featureRow(_ text: String) -> some View {
        Label {
            CommonText(text: text, font: Font.system(size: 14))
        } icon: {
            Image(systemName: "checkmark")
                .foregroundStyle(.tint)
        }
    }

    private var restoreAlertTitle: String {
        switch viewState.restoreResult {
        case .restored:
            return String(localized: "premium-plan-restore-complete")
        case .notFound:
            return String(localized: "premium-plan-restore-not-found")
        case .failed, .none:
            return String(localized: "premium-plan-restore-failed")
        }
    }

    private var restoreAlertBinding: Binding<Bool> {
        Binding(
            get: { viewState.restoreResult != nil },
            set: { if !$0 { viewState.restoreResult = nil } }
        )
    }
}

#Preview {
    NavigationStack {
        PremiumPlanView(viewState: PremiumPlanViewState())
    }
}
