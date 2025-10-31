//
//  SearchView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.networkManager) var networkManager
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var searchPathManager: SearchPathManager
    @StateObject var searchViewModel: SearchViewModel
    
    init(dataManager: DataManager, networkManager: NetworkManager) {
        let searchViewModel = SearchViewModel(dataManager: dataManager, networkManager: networkManager)
        _searchViewModel = StateObject(wrappedValue: searchViewModel)
    }
    
    var body: some View {
        NavigationStack(path: $searchPathManager.routes) {
            ZStack {
                LinearGradient(colors: [.darkRed, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                VStack {
                    TypeOfSearchVIew(searchViewModel: searchViewModel)
                    
                    if searchViewModel.tmdbContents.count != 0 {
                        ContentListView(searchViewModel: searchViewModel)
                    } else {
                        ContentUnavailableView("Results are empty", systemImage: "person.crop.badge.magnifyingglass", description: Text("Use the search bar to find movies or tv shows."))
                            .foregroundStyle(.white)
                        Spacer()
                    }
                }
            }
            .navigationDestination(for: SearchRoute.self) { route in
                switch route {
                case .searchDetails(let tmdbId):
                    SearchDetailView(dataManager: dataManager, networkManager: networkManager, tmdbId: tmdbId, typeOfContent: searchViewModel.selectedTypeOfContent)
                case .seasonDetails(let season):
                    SeasonDetailView(season: season)
                }
            }
            .navigationTitle("Search")
            //.navigationBarTitleDisplayMode(.inline)
            .alert("Oups", isPresented: $searchViewModel.showAlert) {
                Button("ok") { }
            } message: {
                Text(searchViewModel.errorMessage)
            }
        }
    }
}

#Preview {
    SearchView(dataManager: DataManager.preview, networkManager: NetworkManager(environment: .testing))
        .environmentObject(SearchPathManager())
}
