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
                    PosterImageView(path: tvShow.showPoster, size: .flexible(maxWidth: 350, maxHeight: 500))
                        .onChange(of: tvShow) {
                            shouldRefresh.toggle()
                        }
                    
                    VStack {
                        ItemMainInfoView(item: tvShow) {
                            VStack(spacing: 10) {
                                CustomDivider()
                                
                                HStack {
                                    Label("\(tvShow.showFirstAirDate)", systemImage: "calendar")
                                    Spacer()
                                    
                                    if tvShow.showInProduction {
                                        Label("In production", systemImage: "video")
                                    } else {
                                        Label(tvShow.showLastAirDate, systemImage: "video.slash")
                                    }
                                }
                                
                                CustomDivider()
                                
                                HStack {
                                    Label("\(tvShow.showNumberOfEpisodes, default: "N/A") episodes", systemImage: "clock")
                                    Spacer()
                                    
                                    Label(tvShow.showVoteAverage == "0" ? "N/A" : tvShow.showVoteAverage + "/10", systemImage: "star.circle")
                                }
                            }
                        }
                        
                        TvShowPriorityAndTagView(tvShow: tvShow)
                        
                        CustomDivider()
                        
                        Toggle("Show reminders", isOn: $tvShow.reminderEnabled)
                            .toggleStyle(CheckToggleStyle())
                            .infoStyle()
                            .padding()
                        
                        if tvShow.reminderEnabled {
                            DatePicker("Reminder date", selection: $tvShow.showReminderDate)
                                .tint(.darkRed)
                                .infoStyle()
                        }
                    }
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
                        .tint(.yellow)
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
            
            ItemTrailerView(item: tvShow)
                    .padding()
                    .id(shouldRefresh)
            
            CustomDivider()
                .padding()
            
            ItemCastView(item: tvShow)
                .padding()
            
            CustomDivider()
                .padding()
            
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
