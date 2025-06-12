import SwiftUI
import Combine
import StoreKit

class ReactionListViewState: ObservableObject {
    @Published var searchText: String = ""
    @Published var showingThmbnail: Bool
    @Published var isFetching = true
    @Published var reactionMechanisms: [ReactionMechanism] = []
    @Published var billingAlert = false
    @Published var completeAlert = false
    @Published var errorAlert = false
    @Published var sheet: ReactionListViewSheet?
    @Published var destination: ReactionMechanism?

    // 反応機構の言語
    @Published var reactionMechanismIdentifier: String

    private let userDefaultsRepository = UserDefaultRepository()
    private let reactionRepository = ReactionMechanismRepository()

    init(showingThmbnail: Bool) {
        self.reactionMechanismIdentifier = userDefaultsRepository.reactionMechanismLanguage
        self.showingThmbnail = showingThmbnail
    }

    var showingReactions: [ReactionMechanism] {
        if searchText.isEmpty {
            return reactionMechanisms
        } else {
            return reactionMechanisms.filter { reactionMechanisms -> Bool in
                for suggestion in reactionMechanisms.suggestions {
                    if suggestion.uppercased().contains(searchText.uppercased()) {
                        return true
                    }
                }
                return false
            }
        }
    }

    func onAppear() {
        reactionMechanismIdentifier = userDefaultsRepository.reactionMechanismLanguage
        showingThmbnail = userDefaultsRepository.showThmbnail

        guard reactionMechanisms.isEmpty else {
            return
        }
        Task { @MainActor in
            do {
                let reactionMechanisms = try await reactionRepository.fetchMechanisms(reactionsEndpoint: EnvironmentVariable.shared.getReactionsEndpoint)
                self.reactionMechanisms = reactionMechanisms
                self.isFetching = false
            } catch {
                self.isFetching = false
            }
        }
    }

    func clearSearchText() {
        searchText = ""
    }

    func tapped(reactionMechanism: ReactionMechanism) {
        guard userDefaultsRepository.enableDetaileAbility else {
            // 未課金なのでアラートを表示
            billingAlert = true
            return
        }

        destination = reactionMechanism
    }

    func purchase() {
        isFetching = true
        Task { @MainActor in
            do {
                let productIdList = ["detail_available"]
                let products: [Product] = try await Product.products(for: productIdList)
                guard let product = products.first else {
                    isFetching = false
                    errorAlert = true
                    return
                }
                let transaction = try await purchase(product: product)
                userDefaultsRepository.setEnableDetaileAbility(true)
                await transaction.finish()
                isFetching = false
                completeAlert = true
            } catch {
                isFetching = false
                errorAlert = true
            }
        }
    }

    func restore() {
        isFetching = true
        Task { @MainActor in
            do {
                try await AppStore.sync()

                var validSubscription: StoreKit.Transaction?
                for await verificationResult in Transaction.currentEntitlements {
                    if case .verified(let transaction) = verificationResult,
                       transaction.productType == .autoRenewable && !transaction.isUpgraded {
                        validSubscription = transaction
                    }
                }

                guard validSubscription?.productID == nil else {
                    // リストア対象じゃない場合
                    errorAlert = true
                    return
                }

                // 特典を付与
                userDefaultsRepository.setEnableDetaileAbility(true)
                isFetching = false
                completeAlert = true
            } catch {
                isFetching = false
                errorAlert = true
            }
        }
    }

    private func purchase(product: Product) async throws -> StoreKit.Transaction {
        // Product.PurchaseResultの取得
        let purchaseResult: Product.PurchaseResult
        do {
            purchaseResult = try await product.purchase()
        } catch Product.PurchaseError.productUnavailable {
            throw SubscribeError.productUnavailable
        } catch Product.PurchaseError.purchaseNotAllowed {
            throw SubscribeError.purchaseNotAllowed
        } catch {
            throw SubscribeError.otherError
        }

        // VerificationResultの取得
        let verificationResult: VerificationResult<StoreKit.Transaction>
        switch purchaseResult {
        case .success(let result):
            verificationResult = result
        case .userCancelled:
            throw SubscribeError.userCancelled
        case .pending:
            throw SubscribeError.pending
        @unknown default:
            throw SubscribeError.otherError
        }

        // Transactionの取得
        switch verificationResult {
        case .verified(let transaction):
            return transaction
        case .unverified:
            throw SubscribeError.failedVerification
        }
    }
}
