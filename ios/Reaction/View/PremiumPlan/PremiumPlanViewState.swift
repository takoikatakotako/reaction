import SwiftUI
import RevenueCat

@MainActor
final class PremiumPlanViewState: ObservableObject {
    enum RestoreResult {
        case restored
        case notFound
        case failed
    }

    /// nil は読み込み中、または取得に失敗した状態
    @Published var plan: PremiumPlan?
    @Published var isProcessing = false
    @Published var showingPaywall = false
    @Published var showingManageSubscriptions = false
    @Published var restoreResult: RestoreResult?

    private let purchaseRepository = PurchaseRepository()
    private var observeTask: Task<Void, Never>?

    var isNotSubscribed: Bool {
        plan == .notSubscribed
    }

    var isSubscribed: Bool {
        if case .subscribed = plan {
            return true
        }
        return false
    }

    var statusText: String {
        switch plan {
        case .none:
            return "-"
        case .notSubscribed:
            return String(localized: "premium-plan-status-not-subscribed")
        case .subscribed(_, _, let isTrial):
            return isTrial
                ? String(localized: "premium-plan-status-trial")
                : String(localized: "premium-plan-status-subscribed")
        case .legacyPurchase:
            return String(localized: "premium-plan-status-legacy")
        }
    }

    /// 加入中のとき「次回更新日」または「利用できる期限」（解約済み）を返す
    var expirationRow: (title: String, date: String)? {
        guard case .subscribed(let expirationDate?, let willRenew, _) = plan else {
            return nil
        }
        let title = willRenew
            ? String(localized: "premium-plan-renews-on")
            : String(localized: "premium-plan-available-until")
        return (title, expirationDate.formatted(date: .long, time: .omitted))
    }

    func onAppear() {
        Task {
            await reload()
        }
        // 画面を開いている間に届いた CustomerInfo の更新（購入・解約の反映など）も表示に反映する
        observeTask?.cancel()
        observeTask = Task { [weak self] in
            guard Purchases.isConfigured else {
                return
            }
            for await customerInfo in Purchases.shared.customerInfoStream {
                guard let self else {
                    return
                }
                self.plan = await self.purchaseRepository.premiumPlan(customerInfo: customerInfo)
            }
        }
    }

    func onDisappear() {
        observeTask?.cancel()
        observeTask = nil
    }

    func restore() {
        isProcessing = true
        Task {
            defer { isProcessing = false }
            do {
                let restored = try await purchaseRepository.restorePurchases()
                plan = restored
                restoreResult = restored == .notSubscribed ? .notFound : .restored
            } catch {
                restoreResult = .failed
            }
        }
    }

    func paywallDismissed() {
        Task {
            await reload(fetchPolicy: .fetchCurrent)
        }
    }

    /// 管理シートで解約した直後はキャッシュが古いので、最新を取り直す
    func manageSubscriptionsDismissed() {
        Task {
            await reload(fetchPolicy: .fetchCurrent)
        }
    }

    private func reload(fetchPolicy: CacheFetchPolicy = .cachedOrFetched) async {
        do {
            plan = try await purchaseRepository.fetchPremiumPlan(fetchPolicy: fetchPolicy)
        } catch {
            // 最新の取り直し（.fetchCurrent）に失敗した場合は、表示中のプランを消さずに残す
            if fetchPolicy != .fetchCurrent {
                plan = nil
            }
        }
    }
}
