//
//  DataManager-StoreKit.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 11/11/2025.
//

import Foundation
import StoreKit

extension DataManager {
    
    /// The unique product identifier for unlocking the full version of **MyWatchList**.
    /// This identifier must match the one declared in the `StoreKit Configuration` file
    /// and in App Store Connect. It represents a **non-consumable** product used to unlock
    /// all premium features (unlimited tags, unlimited items, etc.).
    static let premiumProductID = "com.marwen.MyWatchList.premium"
    
    /// Stores and retrieves the purchase state of the premium version.
    /// This property is persisted in `UserDefaults` to quickly determine
    /// whether the user has already unlocked the full version of the app.
    /// - Important: This value is also refreshed from StoreKit via transaction monitoring,
    ///   to ensure it stays consistent even after reinstallation or device changes.
    var fullAppPurchased: Bool {
        get {
            defaults.bool(forKey: "fullAppPurchased")
        }
        set {
            defaults.set(newValue, forKey: "fullAppPurchased")
        }
    }
    
    /// Finalizes a verified transaction and updates the purchase state.
    /// - Parameter transaction: The verified transaction returned by StoreKit.
    /// This method:
    /// 1. Verifies that the product ID matches the premium unlock.
    /// 2. Updates the local `fullAppPurchased` state (handling refunds or revocations).
    /// 3. Marks the transaction as finished to remove it from the pending queue.
    /// - Note: Must be called on the **main actor** because it updates observable properties.
    @MainActor
    func finalize(_ transaction: Transaction) async {
        guard transaction.productID == Self.premiumProductID else { return }
        
        objectWillChange.send()
        
        // Ensure the flag is false if the purchase was revoked or refunded
        fullAppPurchased = transaction.revocationDate == nil
        
        await transaction.finish()
    }
    
    /// Monitors StoreKit for past and future premium transactions.
    /// This function runs two continuous loops:
    /// - The first checks for **existing entitlements** (previous purchases).
    /// - The second listens for **live transaction updates** (new purchases, refunds, etc.).
    /// The function is designed to run as long as the app is active, typically
    /// launched in the `DataManager` initializer via a detached `Task`.
    func monitorTransactions() async {
        // Retrieve existing verified entitlements (previous purchases)
        for await entitlement in Transaction.currentEntitlements {
            if case let .verified(transaction) = entitlement {
                await finalize(transaction)
            }
        }
        
        // Listen for new transactions or refunds in real time
        for await update in Transaction.updates {
            if let transaction = try? update.payloadValue {
                await finalize(transaction)
            }
        }
    }
    
    /// Initiates the purchase process for the premium product.
    /// - Parameter product: The `Product` instance to purchase (retrieved from StoreKit).
    /// - Throws: An error if the purchase fails, is cancelled, or cannot be verified.
    /// This method automatically finalizes the transaction upon successful verification.
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        if case let .success(validation) = result {
            try await finalize(validation.payloadValue)
        }
    }
    
    /// Loads the available StoreKit products for **MyWatchList**.
    /// This method fetches metadata for the premium product (localized name, price, etc.)
    /// and caches it in the `products` property. It is safe to call multiple times,
    /// as it will not reload if the products are already available.
    /// - Important: Must be called on the main actor, as it updates a `@Published` property.
    @MainActor
    func loadProducts() async throws {
        guard products.isEmpty else { return }
        
        // Small delay to ensure StoreKit is fully initialized (avoids race condition)
        try await Task.sleep(for: .seconds(0.2))
        
        // Fetch product info from App Store / StoreKit configuration
        products = try await Product.products(for: [Self.premiumProductID])
    }
}
