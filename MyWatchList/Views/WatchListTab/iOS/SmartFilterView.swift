//
//  SmartFilterView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 05/10/2025.
//

import SwiftUI

struct SmartFilterView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    @ObservedObject var watchListViewModel: WatchListViewModel
    
    private let generalFilters: [Filter] = [.movies, .tvShows]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.red.mix(with: .black, by: 0.5), .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            List {
                Section("General filters") {
                    ForEach(generalFilters) { filter in
                        Button(filter.name, systemImage: filter.icon) {
                            watchListViewModel.selectedFilter = filter
                            dismiss()
                        }
                        .foregroundStyle(watchListViewModel.selectedFilter == filter ? .white : .gray)
                    }
                }
                .listRowBackground(Color.yellow.mix(with: .black, by: 0.1).opacity(0.1))
                
                Section("Movie Tags") {
                    CustomTagsListView(watchListViewModel: watchListViewModel, forMovies: true)
                }
                .listRowBackground(Color.yellow.mix(with: .black, by: 0.1).opacity(0.1))
                
                Section("Tv show Tags") {
                    CustomTagsListView(watchListViewModel: watchListViewModel, forMovies: false)
                }
                .listRowBackground(Color.yellow.mix(with: .black, by: 0.1).opacity(0.1))
                
                Section {
                    Button("Add tag", systemImage: "plus") {
                        watchListViewModel.showTagAlert = true
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.white)
                }
                .listRowBackground(Color.yellow.mix(with: .black, by: 0.1).opacity(0.1))
            }
            .scrollContentBackground(.hidden)
        }
        .toolbar {
            
        }
        .alert("Create your own tag", isPresented: $watchListViewModel.showTagAlert) {
            Button("Movie tag") {
                watchListViewModel.dataManager.newTag(isMovieTag: true, name: watchListViewModel.tagName)
            }
            Button("Tv show tag") {
                watchListViewModel.dataManager.newTag(isMovieTag: false, name: watchListViewModel.tagName)
            }
            Button("Cancel", role: .cancel) { }
            
            TextField("Name your tag", text: $watchListViewModel.tagName)
        }
        .alert("Rename tag", isPresented: $watchListViewModel.renamingTag) {
            Button("OK", action: watchListViewModel.completeRename)
            Button("Cancel", role: .cancel) { }
            TextField("New name", text: $watchListViewModel.tagName)
        }
    }
}


#Preview {
    SmartFilterView(watchListViewModel: WatchListViewModel(dataManager: DataManager.preview))
}
