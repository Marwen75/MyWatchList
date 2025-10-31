//
//  EpisodeDetailView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 07/10/2025.
//

import SwiftUI

struct EpisodeDetailView: View {
    @Environment(\.networkManager) var networkManager
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var episode: ShowEpisode
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.darkRed, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            Form {
                Section(episode.episodeName) {
                    if episode.episodeStillPath != "" {
                        PosterImageView(path: episode.episodeStillPath, size: .flexible(maxHeight: 650))
                    } else {
                        ContentUnavailableView("No image available", systemImage: "film")
                    }
                    
                    Toggle(episode.watched ? "Mark as unwatched" : "Mark as watched", isOn: $episode.watched)
                        .infoStyle()
                        .onChange(of: episode.watched) {
                            if let season = episode.season {
                                if season.allEpisodesWatched {
                                    episode.season?.watched = true
                                } else {
                                    episode.season?.watched = false
                                }
                            }
                            dataManager.save()
                        }
                }
                .sectionTitleStyle()
                .listRowBackground(Color.darkYellow.opacity(0.1))
                
                Section("Informations") {
                    HStack {
                        Label("\(episode.episodeRunTime) minutes", systemImage: "clock")
                                
                        Spacer()
                        
                        Label("\(episode.episodeVoteAverage)/10", systemImage: "star.circle")
                            
                    }
                    .infoStyle()
                    
                    Text(episode.episodeOverview)
                        .overviewStyle()
                }
                .sectionTitleStyle()
                .listRowBackground(Color.darkYellow.opacity(0.1))
            }
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    EpisodeDetailView(episode: .exampleEpisode)
        .environmentObject(DataManager.preview)
}
