//
//  SeasonsView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 10/09/2025.
//

import SwiftUI

struct SeasonsView: View {
#if os(macOS)
    @EnvironmentObject var searchPathManager: SearchPathManager
#endif
    @ObservedObject var searchDetailViewModel: SearchDetailViewModel
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(searchDetailViewModel.seasons) { season in
#if os(iOS)
                    NavigationLink(value: SearchRoute.seasonDetails(season: season)) {
                        VStack {
                            Text(season.name ?? "Season \(season.seasonNumber ?? 0)")
                            if let posterPath = season.posterPath {
                                PosterImageView(path: posterPath, size: .flexible(maxWidth: 150, maxHeight: 200))
                            } else {
                                ContentUnavailableView {
                                    Label("No Poster", systemImage: "film")
                                        .font(.system(size: 12).italic())
                                        .foregroundStyle(.white)
                                        .labelStyle(.iconOnly)
                                }
                                .cornerRadius(15)
                                .background {
                                    RoundedRectangle(cornerRadius: 5).stroke(Color.yellow.mix(with: .black, by: 0.1), lineWidth: 1)
                                }
                                .shadow(color: Color.white, radius: 3)
                            }
                        }
                    }
#else
                    VStack {
                        Text(season.name ?? "Season \(season.seasonNumber ?? 0)")
                        if let posterPath = season.posterPath {
                            PosterImageView(path: posterPath, size: .flexible(maxWidth: 150, maxHeight: 200))
                        } else {
                            ContentUnavailableView {
                                Label("No Poster", systemImage: "film")
                                    .font(.system(size: 12).italic())
                                    .foregroundStyle(.white)
                                    .labelStyle(.iconOnly)
                            }
                            .cornerRadius(15)
                            .background {
                                RoundedRectangle(cornerRadius: 5).stroke(Color.yellow.mix(with: .black, by: 0.1), lineWidth: 1)
                            }
                            .shadow(color: Color.white, radius: 3)
                        }
                    }
                    .onTapGesture {
                        searchPathManager.push(to: .seasonDetails(season: season))
                    }
#endif
                }
            }
        }
        .safeAreaPadding([.leading, .top, .bottom], 10)
    }
}

#Preview {
    SeasonsView(searchDetailViewModel: SearchDetailViewModel(dataManager: DataManager.preview, networkManager: NetworkManager(environment: .testing), tmdbId: 1409, typeOfContent: .shows))
}
