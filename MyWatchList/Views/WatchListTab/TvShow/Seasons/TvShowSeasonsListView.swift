//
//  TvShowSeasonsListView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 04/10/2025.
//

import SwiftUI

struct TvShowSeasonsListView: View {
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var tvShow: TvShow
    
#if os(macOS)
    @Binding var showSeasonSheet: Bool
#endif
    
    var body: some View {
#if os(iOS)
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(tvShow.showSeasons, id: \.self) { season in
                    NavigationLink(value: WatchListRoute.seasonDetails(season: season)) {
                        SeasonMiniView(season: season)
                    }
                    .accessibilityIdentifier("seasonCell_\(tvShow.showTitle.replacingOccurrences(of: " ", with: "_"))_\(season.seasonSeasNumber)")
                    .infoStyle()
                }
            }
        }
        .safeAreaPadding([.leading, .top, .bottom], 10)
#else
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(tvShow.showSeasons, id: \.self) { season in
                    SeasonMiniView(season: season)
                        .infoStyle()
                        .onTapGesture {
                            dataManager.selectedSeason = season
                            showSeasonSheet.toggle()
                        }
                }
            }
        }
        .safeAreaPadding([.leading, .top, .bottom], 10)
#endif
    }
}

#Preview {
    #if os(macOS)
    TvShowSeasonsListView(tvShow: .example, showSeasonSheet: .constant(false))
        .environmentObject(DataManager.preview)
    #else
    TvShowSeasonsListView(tvShow: .example)
        .environmentObject(DataManager.preview)
    #endif
}
