//
//  ContentView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

#if os(macOS)
import SwiftUI

struct ContentView: View {
    @Environment(\.networkManager) var networkManager
    @EnvironmentObject var dataManager: DataManager
    
    @ObservedObject var contentViewViewModel: WatchListViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.red.mix(with: .black, by: 0.5), .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack {
                switch dataManager.selectedFilter?.typeOfContent {
                case .movies:
                    List(selection: $dataManager.selectedMovie) {
                        Section("Not seen yet") {
                            ForEach(dataManager.fetchMovies().filter {!$0.watched}, id: \.self) { movie in
                                NavigationLink(value: movie) {
                                    ContentViewMovieRow(movie: movie)
                                }
                            }
                            .onDelete(perform: contentViewViewModel.deleteMovie)
                            .listRowBackground(Color.yellow.mix(with: .black, by: 0.3).opacity(0.1))
                        }
                        
                        Section("Watched") {
                            ForEach(dataManager.fetchMovies().filter {$0.watched}, id: \.self) { movie in
                                NavigationLink(value: movie) {
                                    ContentViewMovieRow(movie: movie)
                                }
                            }
                            .onDelete(perform: contentViewViewModel.deleteMovie)
                            .listRowBackground(Color.yellow.mix(with: .black, by: 0.3).opacity(0.1))
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.automatic)
                    .padding()
                    .searchable(text: $dataManager.searchText, prompt: "Filter by name, genres, actors etc")
                    .toolbar {
                        ToolbarItem(content: ContentViewToolbar.init)
                    }
                case .shows:
                    List(selection: $dataManager.selectedShow) {
                        Section("Not seen yet") {
                            ForEach(dataManager.fetchTvShows().filter {!$0.watched}, id: \.self) { show in
                                NavigationLink(value: show) {
                                    ContentViewTvShowRow(tvShow: show)
                                }
                            }
                            .onDelete(perform: contentViewViewModel.deleteTvShow)
                            .listRowBackground(Color.black.opacity(0))
                        }
                        
                        Section("Watched") {
                            ForEach(dataManager.fetchTvShows().filter {$0.watched}, id: \.self) { show in
                                NavigationLink(value: show) {
                                    ContentViewTvShowRow(tvShow: show)
                                }
                            }
                            .onDelete(perform: contentViewViewModel.deleteTvShow)
                            .listRowBackground(Color.black.opacity(0))
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.automatic)
                    .padding()
                    .searchable(text: $dataManager.searchText, prompt: "Filter by name, genres, actors etc")
                    .toolbar {
                        ToolbarItem(content: ContentViewToolbar.init)
                    }
                case .none:
                    EmptyView()
                }
            }
            .navigationTitle("My watch list")
        }
    }
}

#Preview {
    NavigationStack {
        ContentView(contentViewViewModel: WatchListViewModel(dataManager: DataManager.preview))
            .environmentObject(DataManager.preview)
    }
}
#endif
