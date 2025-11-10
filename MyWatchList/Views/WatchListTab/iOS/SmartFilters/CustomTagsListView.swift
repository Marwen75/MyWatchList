//
//  CustomTagsListView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 05/10/2025.
//

import SwiftUI

struct CustomTagsListView: View {
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var watchListViewModel: WatchListViewModel
    @Environment(\.dismiss) var dismiss
    var forMovies: Bool
    
    var body: some View {
        ForEach(forMovies ? watchListViewModel.movieTags : watchListViewModel.showTags) { filter in
            Button(filter.name, systemImage: filter.icon) {
                watchListViewModel.selectedFilter = filter
                dismiss()
            }
            .foregroundStyle(watchListViewModel.selectedFilter == filter ? .white : .gray)
            .badge(forMovies ? filter.tag?.tagMovies.count ?? 0 : filter.tag?.tagTvShows.count ?? 0)
            .contextMenu {
                Button {
                    watchListViewModel.rename(filter)
                } label: {
                    Label("Rename", systemImage: "pencil")
                }
            }
        }
        .onDelete(perform: forMovies ? watchListViewModel.deleteMovieTag : watchListViewModel.deleteShowTag)
    }
}

#Preview {
    CustomTagsListView(watchListViewModel: WatchListViewModel(dataManager: DataManager.preview), forMovies: true)
        .environmentObject(DataManager.preview)
}
