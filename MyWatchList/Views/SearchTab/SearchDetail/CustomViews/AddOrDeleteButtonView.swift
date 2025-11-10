//
//  AddOrDeleteButtonView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 08/11/2025.
//

import SwiftUI

struct AddOrDeleteButtonView: View {
    @ObservedObject var searchDetailViewModel: SearchDetailViewModel
    @EnvironmentObject var searchPathManager: SearchPathManager
    
    var body: some View {
        HStack {
            Spacer()
            if searchDetailViewModel.contentAlreadySaved {
                Button {
                    searchDetailViewModel.AddOrDeleteContent()
                    searchPathManager.pop()
                } label: {
                    Label("Remove from watchlist", systemImage: "trash")
                        .fontWeight(.semibold)
                }
                .buttonStyle(.glassProminent)
                .tint(.clear)
                .foregroundStyle(.yellow)
                .accessibilityIdentifier("removeButton")
                .padding()
            } else {
                Menu {
                    Text("Add a watch priority to this content")
                    
                    Divider()
                    
                    ForEach(WatchPriority.allCases) { priority in
                        Button {
                            searchDetailViewModel.AddOrDeleteContent(withPriority: priority)
                            searchPathManager.pop()
                        } label: {
                            Label(priority.displayName, systemImage: priority.icon)
                                .tint(.yellow)
                        }
                        .accessibilityIdentifier("priorityButton_\(priority.id)")
                    }
                } label: {
                    Label("Add to watchlist", systemImage: "list.and.film")
                        .fontWeight(.semibold)
                }
                .buttonStyle(.glassProminent)
                .tint(.clear)
                .foregroundStyle(.yellow)
                .accessibilityIdentifier("addMenuButton")
                .padding()
            }
            
            Spacer()
        }
    }
}

#Preview {
    AddOrDeleteButtonView(searchDetailViewModel: SearchDetailViewModel(dataManager: DataManager.preview, networkManager: NetworkManager(environment: .testing), tmdbId: 1409, typeOfContent: .shows))
}
