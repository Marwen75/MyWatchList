//
//  WatchTvShowView.swift
//  MWLWatch Watch App
//
//  Created by Marwen Haouacine on 22/11/2025.
//

import SwiftUI

struct WatchTvShowView: View {
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var show: TvShow
    
    @State private var expandedSeasons: Set<Int> = []
    @State private var nextEp: ShowEpisode?
    @State private var overviewExpanded = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                WatchPosterView(posterPath: show.showPoster)
                
                HStack(spacing: 10) {
                    WatchCircularProgressView(progress: show.showProgress, width: 32, height: 32)
                    if let nextEp {
                        VStack {
                            Text(nextEp.formattedNextEp)
                                .font(.footnote)
                                .fontDesign(.monospaced)
                                .foregroundStyle(.white.opacity(0.7))
                            Text(nextEp.episodeName)
                                .font(.footnote)
                                .fontDesign(.monospaced)
                                .foregroundStyle(.white.opacity(0.7))
                        }
                    } else {
                        Text("All episodes watched!")
                            .font(.caption)
                            .fontDesign(.monospaced)
                            .foregroundStyle(.yellow)
                            .padding(.top, 5)
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(overviewExpanded ? show.showOverview : String(show.showOverview.prefix(90) + "..."))
                        .font(.footnote)
                        .fontDesign(.monospaced)
                        .fontWeight(.thin)
                        .italic()
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Button(overviewExpanded ? "Show Less" : "Read More") {
                        withAnimation {
                            overviewExpanded.toggle()
                        }
                    }
                    .foregroundStyle(.white)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .buttonStyle(.borderless)
                }
                .padding(.horizontal)
                
                Divider().opacity(0.3)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(show.showSeasons, id: \.self) { season in
                        seasonSection(season)
                    }
                }
            }
            .padding([.leading, .trailing, .bottom])
        }
        .navigationTitle(show.showTitle)
        .navigationBarTitleDisplayMode(.inline)
        .scrollIndicators(.hidden)
        .background(LinearGradient(colors: [.darkRed, .black], startPoint: .topLeading, endPoint: .bottomTrailing))
        .onAppear(perform: computeNextEpisode)
    }
    
    @ViewBuilder
    private func seasonSection(_ season: ShowSeason) -> some View {
        let seasonNum = season.seasonSeasNumber
        let expanded = expandedSeasons.contains(seasonNum)
        
        VStack(alignment: .leading, spacing: 10) {
            Button {
                toggleSeason(season)
            } label: {
                HStack {
                    Text("Season \(seasonNum)")
                        .font(.caption)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Image(systemName: expanded ? "chevron.down" : "chevron.right")
                        .foregroundStyle(.white)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 4)
            }
            .buttonStyle(.plain)
            
            if expanded {
                Divider().opacity(0.2)
                
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(season.seasonEpisodes, id: \.self) { ep in
                        episodeRow(ep)
                    }
                }
                .padding(.leading, 6)
            }
        }
        .padding(.vertical, 6)
    }
    
    @ViewBuilder
    private func episodeRow(_ ep: ShowEpisode) -> some View {
        Button {
            toggleEpisode(ep)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("E\(ep.episodeNum)")
                        .font(.footnote)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.white.opacity(ep.watched ? 0.4 : 0.9))
                    
                    Text(ep.episodeName)
                        .font(.footnote)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.white.opacity(ep.watched ? 0.4 : 0.9))
                }
                
                Spacer()
                
                Image(systemName: ep.watched ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(ep.watched ? .yellow : .white)
            }
            .padding([.vertical, .horizontal], 6)
        }
        .buttonStyle(.plain)
        .padding(.vertical, 2)
    }
    
    private func computeNextEpisode() {
        nextEp = show.nextUnwatchedEpisode()
    }
    
    private func toggleSeason(_ season: ShowSeason) {
        let num = season.seasonSeasNumber
        if expandedSeasons.contains(num) {
            expandedSeasons.remove(num)
        } else {
            expandedSeasons.insert(num)
        }
    }
    
    private func toggleEpisode(_ ep: ShowEpisode) {
        withAnimation {
            ep.watched.toggle()
            dataManager.save()
            computeNextEpisode()
        }
    }
}

#Preview {
    NavigationStack {
        WatchTvShowView(show: DataManager.preview.fetchTvShows().first!)
            .environmentObject(DataManager.preview)
    }
}
