import StoreKit

@Observable
final class SubscriptionManager {
    var isSubscribed: Bool = false
    var products: [Product] = []

    var monthlyPrice: String? {
        products.first(where: { $0.id == "com.zzoutuo.JobRig.monthly" })?.displayPrice
    }

    var yearlyPrice: String? {
        products.first(where: { $0.id == "com.zzoutuo.JobRig.yearly" })?.displayPrice
    }

    func loadProducts() async {
        do {
            products = try await Product.products(for: [
                "com.zzoutuo.JobRig.monthly",
                "com.zzoutuo.JobRig.yearly",
                "com.zzoutuo.JobRig.lifetime"
            ])
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    func checkSubscriptionStatus() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if transaction.productID == "com.zzoutuo.JobRig.monthly" ||
                    transaction.productID == "com.zzoutuo.JobRig.yearly" ||
                    transaction.productID == "com.zzoutuo.JobRig.lifetime" {
                    isSubscribed = true
                    return
                }
            }
        }
        isSubscribed = false
    }

    func purchase(tier: SubscriptionTier) async {
        let productID = tier.rawValue
        guard let product = products.first(where: { $0.id == productID }) else { return }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                await checkSubscriptionStatus()
            case .pending, .userCancelled:
                break
            @unknown default:
                break
            }
        } catch {
            print("Purchase failed: \(error)")
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await checkSubscriptionStatus()
        } catch {
            print("Restore failed: \(error)")
        }
    }

    private func checkVerified(_ result: VerificationResult<StoreKit.Transaction>) throws -> StoreKit.Transaction {
        switch result {
        case .unverified(_, let error):
            throw error
        case .verified(let transaction):
            return transaction
        }
    }
}
