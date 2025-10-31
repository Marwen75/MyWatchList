//
//  SeasonDetailSheetView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 10/10/2025.
//

#if os(macOS)
import SwiftUI

struct SeasonDetailSheetView: View {
    @Environment(\.networkManager) var networkManager
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var season: ShowSeason
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .topTrailing) {
                VStack {
                    HStack {
                        if season.seasonPoster != "" {
                            PosterImageView(path: season.seasonPoster, size: .flexible(maxWidth: 100, maxHeight: 150))
                        } else {
                            ContentUnavailableView("No Poster Found", image: "film")
                        }
                        
                        SeasonMainInfoView(season: season)
                    }
                    
                    ForEach(season.seasonEpisodes, id: \.self) { episode in
                        VStack {
                            HStack {
                                Text("\(episode.episodeNumber)" + ". " + episode.episodeName)
                                    .foregroundStyle(episode.watched ? .gray : .white)
                                
                                Spacer()
                                
                                Image(systemName: "checkmark.seal.fill")
                                    .opacity(episode.watched ? 1 : 0)
                            }
                            
                            VStack {
                                AsyncImage(url: networkManager.imageURL.appending(path: episode.episodeStillPath)) { image in
                                    image
                                        .resizable()
                                        .frame(maxHeight: 180)
                                        .scaledToFit()
                                        .cornerRadius(5)
                                        .opacity(episode.watched ? 0.4 : 1)
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                HStack {
                                    Label("\(episode.episodeRunTime) minutes", systemImage: "clock")
                                    
                                    Spacer()
                                    
                                    Label("\(episode.episodeVoteAverage)/10", systemImage: "star.circle")
                                }
                                
                                Text(episode.episodeOverview)
                            }
                        }
                        .font(.system(size: 11)).italic()
                        .foregroundStyle(episode.watched ? .gray : .white)
                        .padding()
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
                .padding()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "multiply.circle.fill")
                }
                .foregroundStyle(.white)
                .buttonSizing(.fitted)
            }
        }
        .background(.linearGradient(colors: [.darkRed, .black], startPoint: .top, endPoint: .bottom))
        .padding()
    }
}

#Preview {
    SeasonDetailSheetView(season: .example)
        .environmentObject(DataManager.preview)
}
#endif
