//
//  SearchDetailView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import SwiftUI
import YouTubePlayerKit

struct SearchDetailView: View {
    @Environment(\.networkManager) var networkManager
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var searchPathManager: SearchPathManager
    
    @StateObject var searchDetailViewModel: SearchDetailViewModel
    
    init(dataManager: DataManager, networkManager: NetworkManager, tmdbId: Int, typeOfContent: TypeOfContent) {
        let searchDetailViewModel = SearchDetailViewModel(dataManager: dataManager, networkManager: networkManager, tmdbId: tmdbId, typeOfContent: typeOfContent)
        _searchDetailViewModel = StateObject(wrappedValue: searchDetailViewModel)
    }
    
    var body: some View {
        #if os(iOS)
        Form {
            Section(searchDetailViewModel.typeOfContent == .movies ? searchDetailViewModel.tmdbContent?.title ?? "" : searchDetailViewModel.tmdbContent?.name ?? "") {
                PosterView(searchDetailViewModel: searchDetailViewModel)
            }
            .listRowBackground(Color.yellow.mix(with: .black, by: 0.1).opacity(0.1))
            
            if searchDetailViewModel.typeOfContent == .shows {
                Section(searchDetailViewModel.seasons.count > 1 ? "Seasons" : "Season") {
                    SeasonsView(searchDetailViewModel: searchDetailViewModel)
                }
                .listRowBackground(Color.yellow.mix(with: .black, by: 0.1).opacity(0.1))
            }
            
            Section("Informations") {
                MainInfoView(searchDetailViewModel: searchDetailViewModel)
            }
            .listRowBackground(Color.yellow.mix(with: .black, by: 0.1).opacity(0.1))
            
            Section("Trailer") {
                TrailerView(searchDetailViewModel: searchDetailViewModel)
            }
            .listRowBackground(Color.yellow.mix(with: .black, by: 0.1).opacity(0.1))
            
            Section("Cast") {
                CastView(searchDetailViewModel: searchDetailViewModel)
            }
            .listRowBackground(Color.yellow.mix(with: .black, by: 0.1).opacity(0.1))
            
            Section {
                HStack {
                    Spacer()
                    
                    Button {
                        searchDetailViewModel.AddOrDeleteContent()
                        searchPathManager.pop()
                    } label: {
                        Label(searchDetailViewModel.contentAlreadySaved ? "Remove from watchlist" : "Add to watchlist", systemImage: "list.and.film")
                    }
                    .accessibilityIdentifier("addButton")
                    .foregroundStyle(.white)
                    .buttonStyle(.glassProminent)
                    .tint(.clear)
                    .padding()
                    
                    Spacer()
                }
            }
            .listRowBackground(Color.yellow.mix(with: .black, by: 0.1).opacity(0.1))
        }
        .onAppear {
            searchDetailViewModel.contentAlreadySaved = searchDetailViewModel.dataManager.isContentAlreadySaved(id: searchDetailViewModel.tmdbId, typeOfContent: searchDetailViewModel.typeOfContent)
        }
        .scrollContentBackground(.hidden)
        .background(.linearGradient(colors: [.red.mix(with: .black, by: 0.5), .black], startPoint: .top, endPoint: .bottom))
        .foregroundStyle(.aluminum)
        .alert("Oups", isPresented: $searchDetailViewModel.showAlert) {
            Button("ok") { }
        } message: {
            Text(searchDetailViewModel.errorMessage)
        }
        #else
        ScrollView {
            VStack {
                HStack {
                    BigPosterImageView(maxHeight: 700, path: searchDetailViewModel.tmdbContent?.posterPath ?? "")
                        .frame(maxWidth: 350, maxHeight: 400)
                        
                    MainInfoView(searchDetailViewModel: searchDetailViewModel)
                }
                
                CustomDivider()
                    .padding()
                
                if searchDetailViewModel.typeOfContent == .shows {
                    SeasonsView(searchDetailViewModel: searchDetailViewModel)
                }
                
                CustomDivider()
                    .padding()
                
                TrailerView(searchDetailViewModel: searchDetailViewModel)
                    .padding()
                
                CustomDivider()
                    .padding()
                
                CastView(searchDetailViewModel: searchDetailViewModel)
                    .padding()
                
                CustomDivider()
                    .padding()
                
                Button {
                    searchDetailViewModel.AddOrDeleteContent()
                    searchPathManager.pop()
                } label: {
                    Label(searchDetailViewModel.contentAlreadySaved ? "Remove from watchlist" : "Add to watchlist", systemImage: "list.and.film")
                }
                .foregroundStyle(searchDetailViewModel.contentAlreadySaved ? .yellow.mix(with: .black, by: 0.1) : .waterGreen)
                .buttonStyle(.bordered)
                .padding()
            }
            .padding()
            
            CustomDivider()
                .padding()
        }
        .background(.linearGradient(colors: [.red.mix(with: .black, by: 0.5), .black], startPoint: .top, endPoint: .bottom))
        .foregroundStyle(.aluminum)
        .alert("Oups", isPresented: $searchDetailViewModel.showAlert) {
            Button("ok") { }
        } message: {
            Text(searchDetailViewModel.errorMessage)
        }
        #endif
    }
}

#Preview {
    SearchDetailView(dataManager: DataManager.preview, networkManager: NetworkManager(environment: .testing), tmdbId: 1409, typeOfContent: .shows)
        .environmentObject(SearchPathManager())
}
