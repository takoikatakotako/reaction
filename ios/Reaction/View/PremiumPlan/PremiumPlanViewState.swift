import SwiftUI

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
            await reload()
        }
    }

    func manageSubscriptionsDismissed() {
        Task {
            await reload()
        }
    }

    private func reload() async {
        do {
            plan = try await purchaseRepository.fetchPremiumPlan()
        } catch {
            plan = nil
        }
    }
}
