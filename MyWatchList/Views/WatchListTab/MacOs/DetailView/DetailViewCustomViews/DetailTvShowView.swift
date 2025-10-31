//
//  DetailTvShowView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 10/10/2025.
//
#if os(macOS)
import SwiftUI

struct DetailTvShowView: View {
    @Environment(\.networkManager) var networkManager
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var tvShow: TvShow
    
    @State private var shouldRefresh = false
    @State private var showSeasonSheet = false
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    PosterImageView(tvShow.showPoster, size: .flexible(maxWidth: 350, maxHeight: 700))
                        .onChange(of: tvShow) {
                            shouldRefresh.toggle()
                        }
                    
                    TvShowMainInfoView(tvShow: tvShow)
                }
                
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
                        .tint(Color.darkYellow)
                }
                .infoStyle()
                .padding()
                
            }
            .padding()
            
            CustomDivider()
                .padding()
          
            TvShowSeasonsListView(tvShow: tvShow, showSeasonSheet: $showSeasonSheet)
                .padding()
            
            
            CustomDivider()
                .padding()
            
            TvShowTrailerView(tvShow: tvShow)
                    .padding()
                    .id(shouldRefresh)
            
            CustomDivider()
                .padding()
            
            TvShowCastView(tvShow: tvShow)
                .padding()
            
            CustomDivider()
                .padding()
            
            Button {
                tvShow.watched.toggle()
            } label: {
                Text(tvShow.watched ? "Mark as unwatched" : "Mark as watched")
            }
            .frame(width: 200, height: 150)
            .padding()
            .buttonStyle(.borderedProminent)
            .tint(tvShow.watched ? Color.darkGreen : Color.darkYellow)
        }
        .background(.linearGradient(colors: [.darkRed, .black], startPoint: .top, endPoint: .bottom))
        .sheet(isPresented: $showSeasonSheet) {
            if let season = dataManager.selectedSeason {
                SeasonDetailSheetView(season: season)
            }
        }
    }
}

#Preview {
    DetailTvShowView(tvShow: .example)
        .environmentObject(DataManager.preview)
}
#endif
