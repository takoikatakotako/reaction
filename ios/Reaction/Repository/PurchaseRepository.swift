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

    /// 起動時に特典フラグを再評価し、その後は RevenueCat の状態が変わるたびに更新し続ける。
    func observeCustomerInfo() async {
        guard Purchases.isConfigured else {
            return
        }
        await reevaluateOnLaunch()
        for await customerInfo in Purchases.shared.customerInfoStream {
            await updateEnableDetailAbility(customerInfo: customerInfo)
        }
    }

    /// 起動時の再評価。
    ///
    /// customerInfoStream はコールドスタート時の通信に失敗すると値を流さないため、
    /// それだけに頼るとオフラインで使い続けた端末で期限切れ後もフラグが true のまま残る。
    /// 保存済みの CustomerInfo（なければ取得）で判定し、それも取れない場合は
    /// 自前で保存している有効期限で判定する。
    private func reevaluateOnLaunch() async {
        do {
            let customerInfo = try await Purchases.shared.customerInfo()
            await updateEnableDetailAbility(customerInfo: customerInfo)
        } catch {
            await revokeIfStoredExpirationPassed()
        }
    }

    /// CustomerInfo を取得できないときの最後の砦。保存済みの有効期限が過ぎていれば特典を外す
    private func revokeIfStoredExpirationPassed() async {
        guard userDefaultRepository.enableDetailAbility,
              let expirationDate = userDefaultRepository.premiumExpirationDate,
              expirationDate < Date() else {
            return
        }
        // 旧買い切りの購入者は期限がないので外さない
        guard await !hasLegacyPurchaseOnDevice() else {
            return
        }
        userDefaultRepository.setEnableDetailAbility(false)
        userDefaultRepository.setPremiumExpirationDate(nil)
    }

    /// 購入や復元の直後など、手元にある CustomerInfo で特典フラグを更新する
    @discardableResult
    func updateEnableDetailAbility(customerInfo: CustomerInfo) async -> Bool {
        let entitlement = customerInfo.entitlements[Self.entitlementId]
        let isPremium = entitlement?.isActive == true
        let hasLegacyPurchase = await hasLegacyPurchaseOnDevice()

        if hasLegacyPurchase && !isPremium {
            // RevenueCat 導入前に買い切りを買った人は、まだ RevenueCat に購入が
            // 登録されていないことがある。端末の購入履歴を一度だけ送っておく。
            await syncLegacyPurchaseIfNeeded()
        }

        let enabled = isPremium || hasLegacyPurchase
        userDefaultRepository.setEnableDetailAbility(enabled)
        // オフライン時の判定用に有効期限を残す（買い切りなど期限がない場合は nil）
        userDefaultRepository.setPremiumExpirationDate(isPremium ? entitlement?.expirationDate : nil)
        return enabled
    }

    /// 現在の有料プランの状態を取得する。あわせて特典フラグも更新する。
    /// 購入や解約の直後は `.fetchCurrent` を渡してキャッシュではなく最新を取る
    func fetchPremiumPlan(fetchPolicy: CacheFetchPolicy = .cachedOrFetched) async throws -> PremiumPlan {
        guard Purchases.isConfigured else {
            return .notSubscribed
        }
        let customerInfo = try await Purchases.shared.customerInfo(fetchPolicy: fetchPolicy)
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

    func premiumPlan(customerInfo: CustomerInfo) async -> PremiumPlan {
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
