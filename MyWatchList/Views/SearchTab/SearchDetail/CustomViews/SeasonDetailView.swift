//
//  SeasonDetailView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 10/09/2025.
//

import SwiftUI

struct SeasonDetailView: View {
    @Environment(\.networkManager) var networkManager
    let season: Season
    
    var body: some View {
#if os(iOS)
        Form {
            Section(season.seasonNumber != nil ? "Season \(season.seasonNumber, default: "")" : "") {
                if let posterPath = season.posterPath {
                    BigPosterImageView(maxHeight: 650, path: posterPath)
                } else {
                    ContentUnavailableView("No Poster Available", systemImage: "film")
                }
            }
            .sectionTitleStyle()
            .listRowBackground(Color.yellow.mix(with: .black, by: 0.1).opacity(0.1))
            
            Section("Informations") {
                HStack {
                    Text("First aired: \(season.airDate ?? "N/A")")
                        
                    Spacer()
                    
                    Text("Episodes: \(season.episodeCount, default: "N.A")")
                }
                .infoStyle()
                
                if let overview = season.overview, overview != "" {
                    Text(overview)
                        .overviewStyle()
                }
            }
            .sectionTitleStyle()
            .listRowBackground(Color.yellow.mix(with: .black, by: 0.1).opacity(0.1))
        }
        .scrollContentBackground(.hidden)
        .background(.linearGradient(colors: [.red.mix(with: .black, by: 0.5), .black], startPoint: .top, endPoint: .bottom))
#else
        ScrollView {
            VStack {
                CustomDivider()
                    .padding()
                
                HStack {
                    if let posterPath = season.posterPath {
                        BigPosterImageView(maxHeight: 400, path: posterPath)
                            .frame(maxWidth: 350, maxHeight: 400)
                    } else {
                        ContentUnavailableView("No Poster Available", systemImage: "film")
                    }
                    
                    VStack {
                        HStack {
                            Text("First aired: \(season.airDate ?? "N/A")")
                                
                            Spacer()
                            
                            Text("Episodes: \(season.episodes?.count, default: "N.A")")
                        }
                        .infoStyle()
                        CustomDivider()
                            .padding()
                        if let overview = season.overview, overview != "" {
                            Text(overview)
                                .overviewStyle()
                            CustomDivider()
                                .padding()
                        }
                        Spacer()
                    }
                }
                
                CustomDivider()
                    .padding()
            }
            .padding()
        }
        .background(.linearGradient(colors: [.red.mix(with: .black, by: 0.5), .black], startPoint: .top, endPoint: .bottom))
        .padding()
#endif
    }
}

#Preview {
    SeasonDetailView(season: Season(airDate: "2010-09-05", episodeCount: 13, id: 3686, name: "Season 3", overview: "This season begins with SAMCRO feeling powerless over Abel’s kidnapping, especially Jax, whose grief sends him into deeper turmoil over his future with the club. The search for Abel sends our guys to Ireland, where Jax faces not only the Irish Republican Army but an untold personal history as well. Meanwhile, still on the lam, Gemma is hit with unexpected news and risks her freedom to deal with it.", posterPath: "/d4lotm8GPAjYwsCjpmwFHIQQzal.jpg", seasonNumber: 3, voteAverage: 8.1, episodes: []))
}
