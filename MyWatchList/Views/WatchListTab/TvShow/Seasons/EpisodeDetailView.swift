//
//  EpisodeDetailView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 07/10/2025.
//

import SwiftUI

struct EpisodeDetailView: View {
    @Environment(\.networkManager) var networkManager
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var errorManager: ErrorManager
    @StateObject var notificationViewModel: NotificationViewModel<ShowEpisode>
    @ObservedObject var episode: ShowEpisode
    
    init(episode: ShowEpisode, dataManager: DataManager) {
        self.episode = episode
        let viewModel = NotificationViewModel(item: episode, dataManager: dataManager)
        _notificationViewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.darkRed, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            Form {
                Section(episode.episodeName) {
                    if episode.episodeStillPath != "" {
                        PosterImageView(path: episode.episodeStillPath, size: .flexible(maxHeight: 650))
                    } else {
                        ContentUnavailableView("No image available", systemImage: "film")
                    }
                    
                    Toggle(episode.watched ? "Mark as unwatched" : "Mark as watched", isOn: $episode.watched)
                        .infoStyle()
                        .tint(.yellow)
                        .onChange(of: episode.watched) {
                            if let season = episode.season {
                                if season.allEpisodesWatched {
                                    episode.season?.watched = true
                                } else {
                                    episode.season?.watched = false
                                }
                            }
                            dataManager.save()
                        }
                }
                .formSectionStyle()
                
                Section("Reminders") {
                    Toggle("Show reminders", isOn: $episode.reminderEnabled)
                        .toggleStyle(CheckToggleStyle())
                        .infoStyle()
                    
                    if episode.reminderEnabled {
                        DatePicker("Reminder date", selection: $episode.episodeReminderDate)
                            .tint(.darkRed)
                            .infoStyle()
                    }
                }
                .formSectionStyle()
                
                Section("Informations") {
                    HStack {
                        Label("\(episode.episodeRunTime) minutes", systemImage: "clock")
                                
                        Spacer()
                        
                        Label("\(episode.episodeVoteAverage)/10", systemImage: "star.circle")
                            
                    }
                    .infoStyle()
                    
                    Text(episode.episodeOverview)
                        .overviewStyle()
                }
                .formSectionStyle()
            }
            .scrollContentBackground(.hidden)
            .onChange(of: notificationViewModel.appError) { _, newError in
                if let error = newError {
                    errorManager.present(error)
                }
            }
            .onChange(of: episode.reminderEnabled) {
                Task {
                    await notificationViewModel.updateReminder()
                }
            }
            .onChange(of: episode.reminderDate) {
                Task {
                    await notificationViewModel.updateReminder()
                }
            }
        }
    }
}

#Preview {
    EpisodeDetailView(episode: .exampleEpisode, dataManager: DataManager.preview)
        .environmentObject(DataManager.preview)
}
