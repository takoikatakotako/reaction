import SwiftUI
import RevenueCat
import RevenueCatUI

/// 有料プランの購入画面
///
/// 中身は RevenueCat の管理画面で設定したペイウォール（オファリング `default`）。
/// 購入・復元で特典が有効になったら `onUnlocked` を呼んで閉じる。
struct PremiumPaywallView: View {
    let onUnlocked: () -> Void

    @Environment(\.dismiss) private var dismiss
    private let purchaseRepository = PurchaseRepository()

    var body: some View {
        PaywallView(displayCloseButton: true)
            .onPurchaseCompleted { customerInfo in
                unlockIfEntitled(customerInfo: customerInfo)
            }
            .onRestoreCompleted { customerInfo in
                unlockIfEntitled(customerInfo: customerInfo)
            }
    }

    private func unlockIfEntitled(customerInfo: CustomerInfo) {
        Task {
            // 復元しても対象の購入がなければ、ペイウォールを開いたままにする
            guard await purchaseRepository.updateEnableDetailAbility(customerInfo: customerInfo) else {
                return
            }
            onUnlocked()
            dismiss()
        }
    }
}
