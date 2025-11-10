//
//  SeasonMainInfoView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 04/10/2025.
//

import SwiftUI

struct SeasonMainInfoView: View {
    @ObservedObject var season: ShowSeason
    
    var body: some View {
        #if os(iOS)
        HStack {
            Label(season.seasonName != "" ? season.seasonName : "Season \(season.seasonNumber)", systemImage: "tv")
            Spacer()
            Label("\(season.seasonAirDate)", systemImage: "calendar")
        }
        .infoStyle()
        
        HStack {
            Label("\(season.seasonEpisodes.count) episodes", systemImage: "clock")
            Spacer()
            Label(season.seasonVoteAverage == "0" ? "N/A" : season.seasonVoteAverage + "/10", systemImage: "star.circle")
        }
        .infoStyle()
        
        Text(season.seasonOverview)
            .overviewStyle()
        #else
        VStack {
            HStack {
                Label(season.seasonName != "" ? season.seasonName : "Season \(season.seasonNumber)", systemImage: "tv")
                Spacer()
                Label("\(season.seasonAirDate)", systemImage: "calendar")
            }
            
            HStack {
                Label("\(season.seasonEpisodes.count) episodes", systemImage: "clock")
                Spacer()
                Label(season.seasonVoteAverage == "0" ? "N/A" : season.seasonVoteAverage + "/10", systemImage: "star.circle")
            }
            
            Text(season.seasonOverview)
                .overviewStyle()
        }
        .infoStyle()
        #endif
    }
}

#Preview {
    SeasonMainInfoView(season: .example)
}
