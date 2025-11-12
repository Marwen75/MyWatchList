//
//  MyWatchListApp.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import SwiftUI

@main
struct MyWatchListApp: App {
#if DEBUG
    @State var networkManager = NetworkManager(environment: .testing)
#else
    @State var networkManager = NetworkManager(environment: .production)
#endif
    @StateObject var dataManager = DataManager()
    @StateObject var errorManager = ErrorManager()
    
    #if os(iOS)
    init() {
        if CommandLine.arguments.contains("enable-testing") {
            // Delete all
            dataManager.deleteAll()
            // Deactivate animations for ui testing
            UIView.setAnimationsEnabled(false)
        }
    }
    #endif
    
    var body: some Scene {
        WindowGroup {
            HomeView(dataManager: dataManager)
                .environment(\.networkManager, networkManager)
                .environment(\.managedObjectContext, dataManager.container.viewContext)
                .environmentObject(dataManager)
                .environmentObject(errorManager)
                .alert(item: $errorManager.alertContext) { context in
                    if let action = context.primaryAction {
                        return Alert(title: Text(context.title),
                                      message: Text(context.message),
                                      primaryButton: .default(Text(context.primaryButtonTitle), action: action),
                                      secondaryButton: .cancel(Text("Cancel")) {errorManager.dismiss()})
                    } else {
                        return Alert(title: Text(context.title),
                                     message: Text(context.message),
                                     dismissButton: .default(Text("Ok")) {errorManager.dismiss()})
                    }
                }
        }
    }
}
