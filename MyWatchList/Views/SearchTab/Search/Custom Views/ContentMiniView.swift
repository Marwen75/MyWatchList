//
//  ContentMiniView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 09/10/2025.
//

import SwiftUI

struct ContentMiniView: View {
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var searchViewModel: SearchViewModel
#if os(macOS)
    @EnvironmentObject var searchPathManager: SearchPathManager
#endif
    @State private var animationAmount = 0.0
    
    let content: TmdbContent
    
    var body: some View {
#if os(iOS)
        NavigationLink(value: SearchRoute.searchDetails(tmdbId: content.id)) {
            if let posterPath = content.posterPath {
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: searchViewModel.networkManager.imageURL.appending(path: posterPath)) { poster in
                        poster
                            .resizable()
                            .frame(height: 200)
                            .cornerRadius(15)
                            .background {
                                RoundedRectangle(cornerRadius: 15).stroke(Color.yellow.mix(with: .black, by: 0.1), lineWidth: 1)
                            }
                            .shadow(color: Color.white, radius: 3)
                            .opacity(searchViewModel.isContentAlreadyInList(contentId: content.id) ? 0.3 : 1)
                            .accessibilityIdentifier("searchResult_\(content.id)")
                    } placeholder: {
                        ProgressView()
                    }
                    
                    if searchViewModel.isContentAlreadyInList(contentId: content.id) {
                        VStack {
                            Image(systemName: "heart.circle")
                                .foregroundStyle(.red)
                                .padding(3)
                        }
                    }
                }
                .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y:1, z: 0))
            } else {
                ContentUnavailableView {
                    Label("No Poster", systemImage: "film")
                        .font(.system(size: 12).italic())
                        .foregroundStyle(.white)
                        .labelStyle(.iconOnly)
                }
                .cornerRadius(15)
                .background {
                    RoundedRectangle(cornerRadius: 15).stroke(Color.yellow.mix(with: .black, by: 0.1), lineWidth: 1)
                }
                .shadow(color: Color.white, radius: 3)
            }
        }
        .contextMenu {
            if searchViewModel.isContentAlreadyInList(contentId: content.id) {
                Button {
                    searchViewModel.selectedTypeOfContent == .movies ? searchViewModel.dataManager.deleteMovieWithId(Int64(content.id)) : searchViewModel.dataManager.deleteShowWithId(Int64(content.id))
                    withAnimation(.spring(duration: 1, bounce: 0.5)) {
                        animationAmount += 360
                    }
                } label: {
                    Label("Remove from watch list", systemImage: "trash.circle")
                }
            }
        }
#else
        if let posterPath = content.posterPath {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: searchViewModel.imageURL.appending(path: posterPath)) { poster in
                    poster
                        .resizable()
                        .frame(maxHeight: 300)
                        .cornerRadius(15)
                        .background {
                            RoundedRectangle(cornerRadius: 15).stroke(Color.yellow.mix(with: .black, by: 0.1), lineWidth: 1)
                        }
                        .shadow(color: Color.white, radius: 3)
                        .opacity(searchViewModel.isContentAlreadyInList(contentId: content.id) ? 0.3 : 1)
                } placeholder: {
                    ProgressView()
                }
                
                if searchViewModel.isContentAlreadyInList(contentId: content.id) {
                    VStack {
                        Image(systemName: "heart.circle")
                            .foregroundStyle(.red)
                            .padding(3)
                    }
                }
            }
            .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y:1, z: 0))
            .onTapGesture {
                searchPathManager.push(to: .searchDetails(tmdbId: content.id))
            }
        } else {
            ContentUnavailableView {
                Label("No Poster available", systemImage: "film")
                    .font(.system(size: 12).italic())
                    .foregroundStyle(.white)
                    .frame(maxHeight: 300)
            }
            .cornerRadius(15)
            .background {
                RoundedRectangle(cornerRadius: 15).stroke(Color.yellow.mix(with: .black, by: 0.1), lineWidth: 1)
            }
            .shadow(color: Color.white, radius: 3)
        }
#endif
    }
}

#Preview {
    ContentMiniView(searchViewModel: SearchViewModel(dataManager: DataManager.preview, networkManager: NetworkManager(environment: .testing)), content: TmdbContent(creators: nil, budget: nil, genres: nil, id: 11, imdbID: nil, overview: nil, posterPath: nil, releaseDate: nil, runtime: nil, title: nil, name: nil, voteAverage: nil, videos: nil, seasons: nil, firstAirDate: nil, lastAirDate: nil, inProduction: nil, numberOfEpisodes: nil, numberOfSeasons: nil, episodeRunTime: nil))
}
