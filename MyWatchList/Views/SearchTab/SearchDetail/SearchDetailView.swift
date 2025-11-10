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
    @EnvironmentObject var errorManager: ErrorManager
    
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
            .formSectionStyle()
            
            if searchDetailViewModel.typeOfContent == .shows {
                Section(searchDetailViewModel.seasons.count > 1 ? "Seasons" : "Season") {
                    SeasonsView(searchDetailViewModel: searchDetailViewModel)
                }
                .formSectionStyle()
            }
            
            Section("Informations") {
                MainInfoView(searchDetailViewModel: searchDetailViewModel)
            }
            .formSectionStyle()
            
            Section("Trailer") {
                TrailerView(searchDetailViewModel: searchDetailViewModel)
            }
            .formSectionStyle()
            
            Section("Cast") {
                CastView(searchDetailViewModel: searchDetailViewModel)
            }
            .formSectionStyle()
            
            Section {
                AddOrDeleteButtonView(searchDetailViewModel: searchDetailViewModel)
            }
            .formSectionStyle()
        }
        .onAppear {
            searchDetailViewModel.contentAlreadySaved = searchDetailViewModel.dataManager.isContentAlreadySaved(id: searchDetailViewModel.tmdbId, typeOfContent: searchDetailViewModel.typeOfContent)
        }
        .scrollContentBackground(.hidden)
        .background(.linearGradient(colors: [.darkRed, .black], startPoint: .top, endPoint: .bottom))
        .foregroundStyle(.white)
        .onChange(of: searchDetailViewModel.appError) { _, newError in
            if let error = newError {
                errorManager.present(error)
            }
        }
        #else
        ScrollView {
            VStack {
                HStack {
                    PosterImageView(path: searchDetailViewModel.tmdbContent?.posterPath ?? "", size: .flexible(maxWidth: 350, maxHeight: 500))
                    
                    VStack {
                        MainInfoView(searchDetailViewModel: searchDetailViewModel)
                        Spacer()
                    }
                }
                
                if searchDetailViewModel.typeOfContent == .shows {
                    CustomDivider()
                        .padding()
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
                .foregroundStyle(searchDetailViewModel.contentAlreadySaved ? .yellow.mix(with: .black, by: 0.1) : .darkGreen)
                .buttonStyle(.bordered)
                .padding()
            }
            .padding()
            
            CustomDivider()
                .padding()
        }
        .background(.linearGradient(colors: [.darkRed, .black], startPoint: .top, endPoint: .bottom))
        .foregroundStyle(.white)
        .onChange(of: searchDetailViewModel.appError) { _, newError in
            if let error = newError {
                errorManager.present(error)
            }
        }
        #endif
    }
}

#Preview {
    SearchDetailView(dataManager: DataManager.preview, networkManager: NetworkManager(environment: .testing), tmdbId: 1409, typeOfContent: .shows)
        .environmentObject(SearchPathManager())
}
