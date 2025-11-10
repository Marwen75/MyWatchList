//
//  SeasonMiniView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 09/10/2025.
//

import SwiftUI

struct SeasonMiniView: View {
    @Environment(\.networkManager) var networkManager
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var season: ShowSeason
    
    @State private var animationAmount = 0.0
    
    var body: some View {
        ZStack {
            VStack {
                Text(season.name ?? "Season \(season.seasonNumber)")
                if season.seasonPoster != "" {
                    PosterImageView(path: season.seasonPoster, size: .flexible(maxWidth: 150, maxHeight: 200))
                            .opacity(season.watched ? 0.3 : 1)
                } else {
                    ContentUnavailableView("No poster", systemImage: "film")
                }
                
                Button {
                    season.watched.toggle()
                    season.seasonEpisodes.forEach { $0.watched = season.watched }
                    
                    if let tvShow = season.tvShow {
                        if tvShow.allSeasonsWatched {
                            season.tvShow?.watched = true 
                        } else {
                            season.tvShow?.watched = false
                        }
                    }
                    dataManager.save()
                    withAnimation(.spring(duration: 1, bounce: 0.5)) {
                        animationAmount += 360
                    }
                } label: {
                    Text(season.watched ? "Mark as unwatched" : "Mark as watched")
                        .font(.system(size: 12, weight: .bold, design: .serif))
                }
                .buttonStyle(.borderedProminent)
                .tint(season.watched ? .yellow.mix(with: .black, by: 0.3) : .darkGreen)
                .frame(width: 150)
            }
            
            if season.watched {
                VStack {
                    Text("Watched")
                        .font(.system(size: 14)).italic().bold().underline()
                    Image(systemName: "checkmark.seal.fill")
                        .imageScale(.large)
                }
                .foregroundStyle(.white)
            }
        }
        .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y:1, z: 0))
    }
}

#Preview {
    SeasonMiniView(season: .example)
        .environmentObject(DataManager.preview)
}
