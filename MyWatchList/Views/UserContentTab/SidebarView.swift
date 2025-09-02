//
//  SidebarView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var dataManager: DataManager
    let smartFilters: [Filter] = [.all, .movie, .show]
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var tags: FetchedResults<Tag>
    
    /// This computed property lets us map our tag we retrieve from core data to match our pre-existing filters
    var tagFilters: [Filter] {
        tags.map { tag in
            Filter(id: tag.tagID, name: tag.tagName, icon: "tag", tag: tag)
        }
    }
    
    var body: some View {
        List(selection: $dataManager.selectedFilter) {
            Section("Smart Filters") {
                ForEach(smartFilters) { filter in
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                    }
                }
            }
            
            Section("Tags") {
                ForEach(tagFilters) { filter in
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                            .badge(filter.tag?.tagContents.count ?? 0)
                    }
                }
            }
        }
    }
}

#Preview {
    SidebarView()
        .environmentObject(DataManager())
}
