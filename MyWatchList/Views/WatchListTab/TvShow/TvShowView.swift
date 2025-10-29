//
//  TvShowView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 27/09/2025.
//

import SwiftUI

struct TvShowView: View {
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var tvShow: TvShow
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.red.mix(with: .black, by: 0.5), .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            Form {
                Section(tvShow.showTitle) {
                    BigPosterImageView(maxHeight: 650, path: tvShow.showPoster)
                    
                    VStack {
                        HStack {
                            Text("\(tvShow.numberOfEpisodesWatched)/\(tvShow.numberOfEpisodes) episodes watched.")
                            if tvShow.watched {
                                Spacer()
                                Image(systemName: "checkmark.seal.fill")
                                    .imageScale(.large)
                            }
                        }
                        ProgressView(value: tvShow.showProgress)
                            .progressViewStyle(.linear)
                            .tint(.yellow.mix(with: .black, by: 0.2))
                    }
                    .infoStyle()
                    
                    TvShowPriorityAndTagView(tvShow: tvShow)
                }
                .sectionTitleStyle()
                .listRowBackground(Color.darkBeige.opacity(0.1))
                
#if os(iOS)
                Section(tvShow.showSeasons.count > 1 ? "Seasons" : "Season") {
                    TvShowSeasonsListView(tvShow: tvShow)
                }
                .sectionTitleStyle()
                .listRowBackground(Color.darkBeige.opacity(0.1))
#endif
                
                Section("Informations") {
                    TvShowMainInfoView(tvShow: tvShow)
                }
                .sectionTitleStyle()
                .listRowBackground(Color.darkBeige.opacity(0.1))
                
                Section("Trailer") {
                    TvShowTrailerView(tvShow: tvShow)
                }
                .sectionTitleStyle()
                .listRowBackground(Color.darkBeige.opacity(0.1))
                
                Section("Cast") {
                    TvShowCastView(tvShow: tvShow)
                }
                .sectionTitleStyle()
                .listRowBackground(Color.darkBeige.opacity(0.1))
            }
            .scrollContentBackground(.hidden)
            .onAppear {
                tvShow.watched = tvShow.numberOfEpisodesWatched == tvShow.numberOfEpisodes
            }
        }
    }
}

#Preview {
    TvShowView(tvShow: .example)
        .environmentObject(DataManager.preview)
}
