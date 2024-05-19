import Foundation
import StoreKit

public enum StoreError: Error {
    case failedVerification
}

class StorekitStore: ObservableObject {
    static let unlockBedtimeScheduleId = "bb.unlock.bedtime.schedule"
    var updateListenerTask: Task<Void, Error>? = nil

    @Published var unlockBedtimeSchedule: Product? = nil
    @Published var hasPurchasedUnlockBedtimeSchedule: Bool = false

    init() {
        updateListenerTask = listenForTransactions()
        Task {
            await requestProducts()
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    @MainActor
    func requestProducts() async {
        do {
            let storeProducts = try await Product.products(for: [StorekitStore.unlockBedtimeScheduleId])
            if storeProducts.count > 0 {
                let foundProduct = storeProducts[0]

                if foundProduct.type == .nonConsumable, foundProduct.id == StorekitStore.unlockBedtimeScheduleId {
                    unlockBedtimeSchedule = foundProduct
                }
            }
        } catch {
            print("Failed product request from the App Store server: \(error)")
        }
    }

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case let .verified(safe):
            return safe
        }
    }

    @MainActor
    func updateCustomerProductStatus() async {
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)

                if transaction.productType == .nonConsumable, transaction.productID == StorekitStore.unlockBedtimeScheduleId {
                    hasPurchasedUnlockBedtimeSchedule = true
                } else {
                    print("Unknown product type or id")
                }
            } catch {
                print("Failed to verify transactions")
            }
        }
    }

    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)

                    await self.updateCustomerProductStatus()

                    await transaction.finish()
                } catch {
                    print("Transaction failed verification")
                }
            }
        }
    }

    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()

        switch result {
        case let .success(verification):
            let transaction = try checkVerified(verification)

            await updateCustomerProductStatus()

            await transaction.finish()
            return transaction
        case .userCancelled, .pending:
            print("Purchase cancelled")
            return nil
        default:
            print("Purchase failed")
            return nil
        }
    }
}
