//
//  SmartFilterView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 05/10/2025.
//

#if os(iOS)
import SwiftUI

struct SmartFilterView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    @ObservedObject var watchListViewModel: WatchListViewModel
    
    private let generalFilters: [Filter] = [.movies, .tvShows]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.darkRed, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            List {
                Section("General filters") {
                    ForEach(generalFilters) { filter in
                        Button(filter.name, systemImage: filter.icon) {
                            watchListViewModel.selectedFilter = filter
                            dismiss()
                        }
                        .foregroundStyle(watchListViewModel.selectedFilter == filter ? .white : .gray)
                        .accessibilityIdentifier(filter.name)
                    }
                }
                .formSectionStyle()
                
                Section("Movie Tags") {
                    CustomTagsListView(watchListViewModel: watchListViewModel, forMovies: true)
                }
                .formSectionStyle()
                
                Section("Tv show Tags") {
                    CustomTagsListView(watchListViewModel: watchListViewModel, forMovies: false)
                }
                .formSectionStyle()
                
                Section {
                    Button("Add tag", systemImage: "plus") {
                        watchListViewModel.showTagAlert = true
                    }
                    .accessibilityIdentifier("addTagButton")
                    .buttonStyle(.plain)
                    .foregroundStyle(.white)
                }
                .formSectionStyle()
            }
            .scrollContentBackground(.hidden)
        }
        .alert("Create your own tag", isPresented: $watchListViewModel.showTagAlert) {
            Button("Movie tag") {
                watchListViewModel.tryNewTag(isMovieTag: true)
            }
            .accessibilityIdentifier("mtButton")
            
            Button("Tv show tag") {
                watchListViewModel.tryNewTag(isMovieTag: false)
            }
            .accessibilityIdentifier("stButton")
            
            Button("Cancel", role: .cancel) { }
            
            TextField("Name your tag", text: $watchListViewModel.tagName)
        }
        .accessibilityIdentifier("ctAlert")
        .alert("Rename tag", isPresented: $watchListViewModel.renamingTag) {
            Button("OK", action: watchListViewModel.completeRename)
            Button("Cancel", role: .cancel) { }
            TextField("New name", text: $watchListViewModel.tagName)
        }
        .sheet(isPresented: $watchListViewModel.showingStore) {
            StoreView()
        }
    }
}


#Preview {
    SmartFilterView(watchListViewModel: WatchListViewModel(dataManager: DataManager.preview))
}
#endif
