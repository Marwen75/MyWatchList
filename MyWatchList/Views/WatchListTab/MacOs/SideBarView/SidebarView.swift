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
    @ObservedObject var sidebarViewViewModel: WatchListViewModel
    
    let smartFilters: [Filter] = [.movies, .tvShows]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.red.mix(with: .black, by: 0.5), .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            List(selection: $sidebarViewViewModel.selectedFilter) { 
                Section("Smart Filters") {
                    ForEach(smartFilters) { filter in
                        NavigationLink(value: filter) {
                            Label(filter.name, systemImage: filter.icon)
                        }
                        .foregroundStyle(sidebarViewViewModel.selectedFilter == filter ? .white : .gray)
                    }
                }
                .listRowBackground(Color.yellow.mix(with: .black, by: 0.3).opacity(0.1))
                
                Section("Movie Tags") {
                    ForEach(sidebarViewViewModel.movieTags) { filter in
                        NavigationLink(value: filter) {
                            Label(filter.name, systemImage: filter.icon)
                                .badge(filter.tag?.tagMovies.count ?? 0)
                        }
                        .foregroundStyle(sidebarViewViewModel.selectedFilter == filter ? .white : .gray)
                        .contextMenu {
                            Button {
                                sidebarViewViewModel.rename(filter)
                            } label: {
                                Label("Rename", systemImage: "pencil")
                            }
                        }
                    }
                    .onDelete(perform: sidebarViewViewModel.deleteMovieTag)
                }
                .listRowBackground(Color.yellow.mix(with: .black, by: 0.3).opacity(0.1))
                
                Section("Tv show Tags") {
                    ForEach(sidebarViewViewModel.showTags) { filter in
                        NavigationLink(value: filter) {
                            Label(filter.name, systemImage: filter.icon)
                                .badge(filter.tag?.tagTvShows.count ?? 0)
                        }
                        .foregroundStyle(sidebarViewViewModel.selectedFilter == filter ? .white : .gray)
                        .contextMenu {
                            Button {
                                sidebarViewViewModel.rename(filter)
                            } label: {
                                Label("Rename", systemImage: "pencil")
                            }
                        }
                    }
                    .onDelete(perform: sidebarViewViewModel.deleteShowTag)
                }
                .listRowBackground(Color.yellow.mix(with: .black, by: 0.3).opacity(0.1))
            }
            .scrollContentBackground(.hidden)
        }
        .toolbar {
            Button("Add tag", systemImage: "plus") {
                sidebarViewViewModel.showTagAlert = true
            }
        }
        .alert("Create your own tag", isPresented: $sidebarViewViewModel.showTagAlert) {
            Button("Movie tag") {
                sidebarViewViewModel.dataManager.newTag(isMovieTag: true, name: sidebarViewViewModel.tagName)
            }
            Button("Tv show tag") {
                sidebarViewViewModel.dataManager.newTag(isMovieTag: false, name: sidebarViewViewModel.tagName)
            }
            Button("Cancel", role: .cancel) { }
            
            TextField("Name your tag", text: $sidebarViewViewModel.tagName)
        }
        .alert("Rename tag", isPresented: $sidebarViewViewModel.renamingTag) {
            Button("OK", action: sidebarViewViewModel.completeRename)
            Button("Cancel", role: .cancel) { }
            TextField("New name", text: $sidebarViewViewModel.tagName)
        }
    }
}

#Preview {
    SidebarView(sidebarViewViewModel: WatchListViewModel(dataManager: DataManager.preview))
        .environmentObject(DataManager.preview)
    
}
#endif
