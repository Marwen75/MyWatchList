//
//  TvShowSeasonDetailView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 04/10/2025.
//

import SwiftUI

struct TvShowSeasonDetailView: View {
    @Environment(\.networkManager) var networkManager
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var season: ShowSeason
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.red.mix(with: .black, by: 0.5), .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            Form {
                Section(season.seasonName) {
                    if season.seasonPoster != "" {
                        BigPosterImageView(maxHeight: 700, path: season.seasonPoster)
                    } else {
                        ContentUnavailableView("No Poster Found", image: "film")
                    }
                    
                    VStack {
                        HStack {
                            Text("\(season.numberOfEpisodesWatched)/\(season.seasonEpisodeCount) episodes watched.")
                            if season.watched {
                                Spacer()
                                Image(systemName: "checkmark.seal.fill")
                                    .imageScale(.large)
                            }
                        }
                        ProgressView(value: season.seasonProgress)
                            .progressViewStyle(.linear)
                            .tint(.darkBeige)
                    }
                    .infoStyle()
                }
                .sectionTitleStyle()
                .listRowBackground(Color.darkBeige.opacity(0.1))
                
                Section("Informations") {
                    SeasonMainInfoView(season: season)
                }
                .sectionTitleStyle()
                .listRowBackground(Color.darkBeige.opacity(0.1))
                
                
                Section("Episodes") {
                    ForEach(season.seasonEpisodes, id: \.self) { episode in
                        NavigationLink(value: WatchListRoute.episodeDetails(episode: episode)) {
                            HStack {
                                Text("\(episode.episodeNumber)" + ". " + episode.episodeName)
                                    .foregroundStyle(episode.watched ? .gray : .aluminum)
                                
                                Spacer()
                                
                                Image(systemName: "checkmark.seal.fill")
                                    .opacity(episode.watched ? 1 : 0)
                            }
                            .infoStyle()
                        }
                        .accessibilityIdentifier("episodeCell_\(episode.episodeNumber)")
                        .contextMenu {
                            Button {
                                episode.watched.toggle()
                                if season.allEpisodesWatched {
                                    season.watched = true
                                } else {
                                    season.watched = false
                                }
                                dataManager.save()
                            } label: {
                                Label(episode.watched ? "Mark as unwatched" : "Mark as watched", systemImage: "eye")
                            }
                        }
                    }
                }
                .sectionTitleStyle()
                .listRowBackground(Color.darkBeige.opacity(0.1))
            }
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    TvShowSeasonDetailView(season: .example)
        .environmentObject(DataManager.preview)
}
