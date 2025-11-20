//
//  SidebarView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

#if os(macOS)
import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var watchListViewModel: WatchListViewModel
    
    let smartFilters: [Filter] = [.movies, .tvShows]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.darkRed, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            List(selection: $watchListViewModel.selectedFilter) {
                Section("Smart Filters") {
                    ForEach(smartFilters) { filter in
                        NavigationLink(value: filter) {
                            Label(filter.name, systemImage: filter.icon)
                        }
                        .foregroundStyle(watchListViewModel.selectedFilter == filter ? .white : .gray)
                    }
                }
                .listRowBackground(Color.darkYellow.opacity(0.1))
                
                Section("Movie Tags") {
                    ForEach(sidebarViewViewModel.movieTags) { filter in
                        NavigationLink(value: filter) {
                            Label(filter.name, systemImage: filter.icon)
                                .badge(filter.tag?.tagMovies.count ?? 0)
                        }
                        .foregroundStyle(watchListViewModel.selectedFilter == filter ? .white : .gray)
                        .contextMenu {
                            Button {
                                watchListViewModel.rename(filter)
                            } label: {
                                Label("Rename", systemImage: "pencil")
                            }
                        }
                    }
                    .onDelete(perform: watchListViewModel.deleteMovieTag)
                }
                .listRowBackground(Color.darkYellow.opacity(0.1))
                
                Section("Tv show Tags") {
                    ForEach(watchListViewModel.showTags) { filter in
                        NavigationLink(value: filter) {
                            Label(filter.name, systemImage: filter.icon)
                                .badge(filter.tag?.tagTvShows.count ?? 0)
                        }
                        .foregroundStyle(watchListViewModel.selectedFilter == filter ? .white : .gray)
                        .contextMenu {
                            Button {
                                watchListViewModel.rename(filter)
                            } label: {
                                Label("Rename", systemImage: "pencil")
                            }
                        }
                    }
                    .onDelete(perform: watchListViewModel.deleteShowTag)
                }
                .listRowBackground(Color.darkYellow.opacity(0.1))
            }
            .scrollContentBackground(.hidden)
        }
        .toolbar {
            Button("Add tag", systemImage: "plus") {
                watchListViewModel.showTagAlert = true
            }
        }
        .alert("Create your own tag", isPresented: $watchListViewModel.showTagAlert) {
            Button("Movie tag") {
                watchListViewModel.tryNewTag(isMovieTag: true)
            }
            Button("Tv show tag") {
                watchListViewModel.tryNewTag(isMovieTag: false)
            }
            Button("Cancel", role: .cancel) { }
            
            TextField("Name your tag", text: $sidebarViewViewModel.tagName)
        }
        .alert("Rename tag", isPresented: $sidebarViewViewModel.renamingTag) {
            Button("OK", action: sidebarViewViewModel.completeRename)
            Button("Cancel", role: .cancel) { }
            TextField("New name", text: $sidebarViewViewModel.tagName)
        }
        .sheet(isPresented: $watchListViewModel.showingStore) {
            StoreView()
                .accessibilityIdentifier("storeView")
        }
    }
}

#Preview {
    SidebarView(watchListViewModel: WatchListViewModel(dataManager: DataManager.preview))
        .environmentObject(DataManager.preview)
    
}
#endif
