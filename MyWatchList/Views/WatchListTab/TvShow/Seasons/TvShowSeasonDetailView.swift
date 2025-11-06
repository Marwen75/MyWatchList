//
//  TvShowSeasonDetailView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 04/10/2025.
//

import SwiftUI

struct TvShowSeasonDetailView: View {
    @Environment(\.networkManager) var networkManager
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var errorManager: ErrorManager
    @StateObject var notificationViewModel: NotificationViewModel<ShowSeason>
    @ObservedObject var season: ShowSeason
    
    init(season: ShowSeason, dataManager: DataManager) {
        self.season = season
        let viewModel = NotificationViewModel(item: season, dataManager: dataManager)
        _notificationViewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.darkRed, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            Form {
                Section(season.seasonName) {
                    if season.seasonPoster != "" {
                        PosterImageView(path: season.seasonPoster, size: .flexible(maxHeight: 700))
                    } else {
                        ContentUnavailableView("No Poster Found", image: "film")
                    }
                    
                    VStack {
                        HStack {
                            Text("\(season.numberOfEpisodesWatched)/\(season.seasonEpisodeCount) episodes watched.")
                            if season.watched {
                                Spacer()
                                Image(systemName: "checkmark.seal.fill")
                                    .imageScale(.large)
                            }
                        }
                        ProgressView(value: season.seasonProgress)
                            .progressViewStyle(.linear)
                            .tint(.yellow)
                    }
                    .infoStyle()
                }
                .formSectionStyle()
                
                Section("Reminders") {
                    Toggle("Show reminders", isOn: $season.reminderEnabled)
                        .toggleStyle(CheckToggleStyle())
                        .infoStyle()
                    
                    if season.reminderEnabled {
                        DatePicker("Reminder date", selection: $season.seasonReminderDate)
                            .tint(.darkRed)
                            .infoStyle()
                    }
                }
                .formSectionStyle()
                
                Section("Informations") {
                    SeasonMainInfoView(season: season)
                }
                .formSectionStyle()
                
                Section("Episodes") {
                    ForEach(season.seasonEpisodes, id: \.self) { episode in
                        NavigationLink(value: WatchListRoute.episodeDetails(episode: episode)) {
                            HStack {
                                Text("\(episode.episodeNumber)" + ". " + episode.episodeName)
                                    .foregroundStyle(episode.watched ? .gray : .white)
                                
                                Spacer()
                                
                                Image(systemName: "checkmark.seal.fill")
                                    .opacity(episode.watched ? 1 : 0)
                            }
                            .infoStyle()
                        }
                        .accessibilityIdentifier("episodeCell_\(episode.episodeNumber)")
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
                .formSectionStyle()
            }
            .scrollContentBackground(.hidden)
            .onChange(of: notificationViewModel.appError) { _, newError in
                if let error = newError {
                    errorManager.present(error)
                }
            }
            .onChange(of: season.reminderEnabled) {
                Task {
                    await notificationViewModel.updateReminder()
                }
            }
            .onChange(of: season.reminderDate) {
                Task {
                    await notificationViewModel.updateReminder()
                }
            }
        }
    }
}

#Preview {
    TvShowSeasonDetailView(season: .example, dataManager: DataManager.preview)
        .environmentObject(DataManager.preview)
}
