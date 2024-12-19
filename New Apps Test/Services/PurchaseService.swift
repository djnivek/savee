//
//  PurchaseService.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 19/12/2024.
//

import StoreKit

final class PurchaseService {

    static let shared = PurchaseService()

    private init() {}
    
    @MainActor
    func fetchProduct() async throws -> Product? {
        do {
            let products = try await Product.products(for: ["com.voodoo.hoost.premium.montly"])
            return products.first
        } catch {
            throw PurchaseError.failedToFetchProducts(error)
        }
    }
    
    @MainActor
    func purchasePremium() async throws -> Bool {
        let product = try await fetchProduct()
        guard let product = product else { return false }
        return try await purchase(product: product)
    }
    
    @MainActor
    func purchase(product: Product) async throws -> Bool {
        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    await transaction.finish()
                    return true

                case .unverified(_, let error):
                    throw PurchaseError.unverifiedTransaction(error)
                }

            case .userCancelled:
                return false

            case .pending:
                return false

            @unknown default:
                throw PurchaseError.unknownResult
            }
        } catch {
            throw PurchaseError.failedToPurchase(error)
        }
    }

    enum PurchaseError: LocalizedError {
        case failedToFetchProducts(Error)
        case failedToPurchase(Error)
        case unverifiedTransaction(Error?)
        case unknownResult

        var errorDescription: String? {
            switch self {
            case .failedToFetchProducts(let error):
                return "Failed to fetch products: \(error.localizedDescription)"

            case .failedToPurchase(let error):
                return "Failed to complete purchase: \(error.localizedDescription)"

            case .unverifiedTransaction(let error):
                return "Unverified transaction: \(error?.localizedDescription ?? "Unknown error")"

            case .unknownResult:
                return "Unknown purchase result"
            }
        }
    }
}
