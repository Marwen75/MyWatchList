//
//  StoreView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 11/11/2025.
//

import SwiftUI
import StoreKit

struct StoreView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    @State private var loadState = LoadState.loaded
    @State private var showingPurchaseError = false
    
    enum LoadState {
        case loading, loaded, error
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack {
                    Image(decorative: "premium")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                    
                    Text("Upgrade Today!")
                        .font(.title.bold())
                        .fontDesign(.rounded)
                        .foregroundStyle(.white)
                    
                    Text("Get the most out of our app.")
                        .font(.title3)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(.black)
                
                ScrollView {
                    VStack {
                        switch loadState {
                        case .loading:
                            Text("Fetching offers...")
                                .font(.title2.bold())
                                .padding(.top, 50)
                            
                            ProgressView()
                                .controlSize(.large)
                            
                        case .loaded:
                            ForEach(dataManager.products) { product in
                                Button {
                                    purchase(product)
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(product.displayName)
                                                .font(.title2.bold())
                                                .fontDesign(.rounded)
                                            
                                            Text(product.description)
                                                .fontDesign(.monospaced)
                                        }
                                        
                                        Spacer()
                                        
                                        Text(product.displayPrice)
                                            .font(.title)
                                            .fontDesign(.rounded)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(.gray.opacity(0.2), in: .rect(cornerRadius: 20))
                                    .contentShape(.rect)
                                }
                                .accessibilityIdentifier("premiumButton_\(product.id)")
                                .buttonStyle(.plain)
                            }
                        case .error:
                            Text("Sorry, an error occured while loading our store. Please try again.")
                                .padding(.top, 50)
                            
                            Button("Try Again") {
                                Task {
                                    await load()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding(20)
                }
                Button("Restore Purchases", action: restore)
                    .fontDesign(.monospaced)
                    .underline()
                
                Button("Cancel") {
                    dismiss()
                }
                .padding(.top, 20)
                .fontDesign(.monospaced)
                .underline()
            }
        }
        .alert("In-app purchases are disabled", isPresented: $showingPurchaseError) {
        } message: {
            Text("""
            You can't purchase the premium unlock because in-app purchases are disabled on this device.
            
            Please ask whomever manages your device for assistance.
            """)
        }
        .onChange(of: dataManager.fullAppPurchased) {
            checkForPurchase()
        }
        .task {
            await load()
        }
    }
    
    func checkForPurchase() {
        if dataManager.fullAppPurchased {
            dismiss()
        }
    }
    
    func purchase(_ product: Product) {
        guard AppStore.canMakePayments else {
            showingPurchaseError.toggle()
            return
        }
        
        Task { @MainActor in
            try await dataManager.purchase(product)
        }
    }
    
    func load() async {
        loadState = .loading
        
        do {
            try await dataManager.loadProducts()
            
            if dataManager.products.isEmpty {
                loadState = .error
            } else {
                loadState = .loaded
            }
        } catch {
            loadState = .error
        }
    }
    
    func restore() {
        Task {
            try await AppStore.sync()
        }
    }
}

#Preview {
    StoreView()
        .environmentObject(DataManager.preview)
}
