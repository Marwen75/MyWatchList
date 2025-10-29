//
//  ContentViewToolbar.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 02/10/2025.
//

#if os(macOS)
import SwiftUI

struct ContentViewToolbar: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        Menu {
            Button(dataManager.filterEnabled ? "Filter Off" : "Filter On") {
                dataManager.filterEnabled.toggle()
            }
            
            Divider()
            
            Picker("Status", selection: $dataManager.filterStatus) {
                Text("All").tag(DataManager.Status.all)
                Text("Watched").tag(DataManager.Status.watched)
                Text("Unwatched").tag(DataManager.Status.unwatched)
            }
            .disabled(!dataManager.filterEnabled)
            
            Picker("Priority", selection: $dataManager.filterPriority) {
                Text("All").tag(-1)
                Text("Watch later").tag(0)
                Text("Must see").tag(1)
                Text("Watch urgently").tag(2)
            }
            .disabled(!dataManager.filterEnabled)
        } label: {
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                .symbolVariant(dataManager.filterEnabled ? .fill : .none)
        }
    }
}

#Preview {
    ContentViewToolbar()
        .environmentObject(DataManager.preview)
}
#endif
