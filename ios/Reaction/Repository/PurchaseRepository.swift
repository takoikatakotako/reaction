import Foundation
import RevenueCat
import StoreKit

/// 有料プランの状態（設定の「有料プラン」画面で表示する）
enum PremiumPlan: Equatable {
    case notSubscribed
    case subscribed(expirationDate: Date?, willRenew: Bool, isTrial: Bool)
    /// 有料プラン提供前の買い切り購入者
    case legacyPurchase
}

/// 課金（RevenueCat）まわり
///
/// 特典の有無は RevenueCat のエンタイトルメント `premium` で判定する。
/// `premium` にはサブスク（premium_monthly）と旧買い切り（detail_available）の
/// 両方を紐付けているので、どちらを買った人も同じ判定で特典が付く。
final class PurchaseRepository {
    static let entitlementId = "premium"

    /// 旧買い切り商品。購入導線は削除済みだが、既存の購入者は当面使えるようにする
    static let legacyProductId = "detail_available"

    private let userDefaultRepository: UserDefaultRepository

    init(userDefaultRepository: UserDefaultRepository = UserDefaultRepository()) {
        self.userDefaultRepository = userDefaultRepository
    }

    static func configure(apiKey: String) {
        #if DEBUG
        Purchases.logLevel = .debug
        #endif
        Purchases.configure(withAPIKey: apiKey)
    }

    /// RevenueCat の状態が変わるたびに特典フラグを更新し続ける。
    /// 起動直後にも現在の状態（キャッシュ）が 1 回流れてくる。
    func observeCustomerInfo() async {
        guard Purchases.isConfigured else {
            return
        }
        for await customerInfo in Purchases.shared.customerInfoStream {
            await updateEnableDetailAbility(customerInfo: customerInfo)
        }
    }

    /// 購入や復元の直後など、手元にある CustomerInfo で特典フラグを更新する
    @discardableResult
    func updateEnableDetailAbility(customerInfo: CustomerInfo) async -> Bool {
        let isPremium = customerInfo.entitlements[Self.entitlementId]?.isActive == true
        let hasLegacyPurchase = await hasLegacyPurchaseOnDevice()

        if hasLegacyPurchase && !isPremium {
            // RevenueCat 導入前に買い切りを買った人は、まだ RevenueCat に購入が
            // 登録されていないことがある。端末の購入履歴を一度だけ送っておく。
            await syncLegacyPurchaseIfNeeded()
        }

        let enabled = isPremium || hasLegacyPurchase
        userDefaultRepository.setEnableDetailAbility(enabled)
        return enabled
    }

    /// 現在の有料プランの状態を取得する。あわせて特典フラグも更新する
    func fetchPremiumPlan() async throws -> PremiumPlan {
        guard Purchases.isConfigured else {
            return .notSubscribed
        }
        let customerInfo = try await Purchases.shared.customerInfo()
        await updateEnableDetailAbility(customerInfo: customerInfo)
        return await premiumPlan(customerInfo: customerInfo)
    }

    /// 購入を復元し、復元後の有料プランの状態を返す
    func restorePurchases() async throws -> PremiumPlan {
        guard Purchases.isConfigured else {
            return .notSubscribed
        }
        let customerInfo = try await Purchases.shared.restorePurchases()
        await updateEnableDetailAbility(customerInfo: customerInfo)
        return await premiumPlan(customerInfo: customerInfo)
    }

    private func premiumPlan(customerInfo: CustomerInfo) async -> PremiumPlan {
        if let entitlement = customerInfo.entitlements[Self.entitlementId], entitlement.isActive {
            if entitlement.productIdentifier == Self.legacyProductId {
                return .legacyPurchase
            }
            return .subscribed(
                expirationDate: entitlement.expirationDate,
                willRenew: entitlement.willRenew,
                isTrial: entitlement.periodType == .trial
            )
        }
        if await hasLegacyPurchaseOnDevice() {
            return .legacyPurchase
        }
        return .notSubscribed
    }

    /// 端末の StoreKit に旧買い切りの購入が残っているか。
    /// RevenueCat と通信できない場合でも既存の購入者が特典を失わないようにするため、
    /// RevenueCat の判定とは別に端末側でも確認する。
    private func hasLegacyPurchaseOnDevice() async -> Bool {
        for await verificationResult in Transaction.currentEntitlements {
            if case .verified(let transaction) = verificationResult,
               transaction.productID == Self.legacyProductId,
               transaction.revocationDate == nil {
                return true
            }
        }
        return false
    }

    private func syncLegacyPurchaseIfNeeded() async {
        guard !userDefaultRepository.didSyncLegacyPurchase else {
            return
        }
        do {
            _ = try await Purchases.shared.syncPurchases()
            userDefaultRepository.setDidSyncLegacyPurchase(true)
        } catch {
            // 次回起動時にまた試す。特典自体は端末の購入履歴で付与済み。
            print("Failed to sync legacy purchase: \(error.localizedDescription)")
        }
    }
}
