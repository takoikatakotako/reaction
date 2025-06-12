import SwiftUI
import StoreKit

class SearchResultViewState: ObservableObject {
    @Published var showingThmbnail: Bool = true
    @Published var selectJapanese: Bool = true
    @Published var isFetching = true
    @Published var reactionMechanisms: [ReactionMechanism] = []
    @Published var billingAlert = false
    @Published var completeAlert = false
    @Published var errorAlert = false
    @Published var destination: ReactionMechanism?

    private let reactionRepository = ReactionMechanismRepository()
    private let userDefaultsRepository = UserDefaultRepository()
    private let searchResultType: SearchTargetType
    private let withoutCheck: Bool
    private let firstCategories: [FirstCategory]

    var navigationTitle: String {
        switch searchResultType {
        case .reactant:
            return String(localized: "search-result-search-reactant")
        case .product:
            return String(localized: "search-result-search-product")
        }
    }

    init(searchResultType: SearchTargetType, withoutCheck: Bool, firstCategories: [FirstCategory]) {
        self.searchResultType = searchResultType
        self.withoutCheck = withoutCheck
        self.firstCategories = firstCategories
    }

    func onAppear() {
        showingThmbnail = userDefaultsRepository.showThmbnail

        guard reactionMechanisms.isEmpty else {
            return
        }
        Task { @MainActor in
            do {
                let reactionMechanisms = try await reactionRepository.fetchMechanisms()
                // 検索結果を取得
                if self.withoutCheck {
                    // チェックしたもの以外を検索
                    self.reactionMechanisms = self.searchReactionsWithoutCheck(originalReactionMechanism: reactionMechanisms)
                } else {
                    // チェックしたものを検索
                    self.reactionMechanisms = self.searchReactionsWithCheck(originalReactionMechanism: reactionMechanisms)
                }
                self.isFetching = false
            } catch {
                self.isFetching = false
            }
        }
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

    //    private func fetchProducts() async throws -> Product? {
    //        let productIdList = ["detail_available"]
    //        let products: [Product] = try await Product.products(for: productIdList)
    //        guard let product = products.first else {
    //            return nil
    //        }
    //        return product
    //    }

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

    private func getTags() -> [String] {
        var tags: [String] = []
        for firstCategory in firstCategories {
            if firstCategory.check {
                tags.append(firstCategory.tag)
            }
            for secondCategory in firstCategory.secondCategories {
                if secondCategory.check {
                    tags.append(secondCategory.tag)
                }
                for thirdCategory in secondCategory.thirdCategories {
                    if thirdCategory.check {
                        tags.append(thirdCategory.tag)
                    }
                }
            }
        }
        return tags
    }

    // 反応機構検索。チェックしたものを検索
    private func searchReactionsWithCheck(originalReactionMechanism: [ReactionMechanism]) -> [ReactionMechanism] {
        var filterdReactionMechanisms: Set<ReactionMechanism> = []
        for reactionMechanism in originalReactionMechanism {
            for tag in self.getTags() {
                // 出発物検索
                if searchResultType == .reactant {
                    if reactionMechanism.reactants.firstIndex(where: {$0 == tag}) != nil {
                        filterdReactionMechanisms.insert(reactionMechanism)
                    }
                }
                // 生成物検索
                if searchResultType == .product {
                    if reactionMechanism.products.firstIndex(where: {$0 == tag}) != nil {
                        filterdReactionMechanisms.insert(reactionMechanism)
                    }
                }
            }
        }
        return sorted(Array(filterdReactionMechanisms))
    }

    // 反応機構検索。チェックしたものを除外
    private func searchReactionsWithoutCheck(originalReactionMechanism: [ReactionMechanism]) -> [ReactionMechanism] {
        var filterdReactionMechanisms: [ReactionMechanism] = originalReactionMechanism
        // チェックしたものを取得
        let searchReactionsWithChecks = searchReactionsWithCheck(originalReactionMechanism: originalReactionMechanism)
        // チェックしたものを除いていく
        for searchReactionsWithCheck in searchReactionsWithChecks {
            if let index = filterdReactionMechanisms.firstIndex(where: {$0 == searchReactionsWithCheck}) {
                filterdReactionMechanisms.remove(at: index)
            }
        }
        return sorted(filterdReactionMechanisms)
    }

    private func sorted(_ originalReactionMechanism: [ReactionMechanism]) -> [ReactionMechanism] {
        return originalReactionMechanism.sorted(by: { lhs, rhs in
            lhs.englishName < rhs.englishName
        })
    }
}
