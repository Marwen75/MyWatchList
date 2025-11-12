//
//  ContentListView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 08/09/2025.
//

import SwiftUI

struct ContentListView: View {
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var searchViewModel: SearchViewModel
    
    var body: some View {
        #if os(iOS)
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 200))], spacing: 8) {
                ForEach(searchViewModel.tmdbContents) { content in
                   ContentMiniView(searchViewModel: searchViewModel, content: content)
                }
            }
            .scrollTargetLayout()
        }
        .safeAreaPadding([.leading, .top, .trailing], 10)
        .onScrollTargetVisibilityChange(idType: TmdbContent.ID.self, threshold: 0.5) { visibleIds in
            guard let lastContent = searchViewModel.tmdbContents.last else { return }
            
            if visibleIds.contains(lastContent.id), !searchViewModel.isFetchingNextPage, searchViewModel.hasMorePages {
                Task {
                    await searchViewModel.fetchNextPage()
                }
            }
        }
        #else
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 200, maximum: 300))], spacing: 8) {
                ForEach(searchViewModel.tmdbContents, id: \.id) { content in
                   ContentMiniView(searchViewModel: searchViewModel, content: content)
                }
            }
            .scrollTargetLayout()
        }
        .safeAreaPadding([.leading, .top, .trailing], 10)
        .onScrollTargetVisibilityChange(idType: TmdbContent.ID.self, threshold: 0.5) { visibleIds in
            guard let lastContent = searchViewModel.tmdbContents.last else { return }
            
            if visibleIds.contains(lastContent.id), !searchViewModel.isFetchingNextPage, searchViewModel.hasMorePages {
                Task {
                    await searchViewModel.fetchNextPage()
                }
            }
        }
        #endif
    }
}

#Preview {
    ContentListView(searchViewModel: SearchViewModel(dataManager: DataManager.preview, networkManager: NetworkManager(environment: .testing)))
}
