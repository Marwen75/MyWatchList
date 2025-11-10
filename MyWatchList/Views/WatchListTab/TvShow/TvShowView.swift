//
//  TvShowView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 27/09/2025.
//

import SwiftUI

struct TvShowView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var errorManager: ErrorManager
    @StateObject var notificationViewModel: NotificationViewModel<TvShow>
    @ObservedObject var tvShow: TvShow
    
    init(tvShow: TvShow, dataManager: DataManager) {
        self.tvShow = tvShow
        let viewModel = NotificationViewModel(item: tvShow, dataManager: dataManager)
        _notificationViewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.darkRed, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            Form {
                Section(tvShow.showTitle) {
                    PosterImageView(path: tvShow.showPoster, size: .flexible(maxHeight: 700))
                    
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
                    
                    TvShowPriorityAndTagView(tvShow: tvShow)
                        .infoStyle()
                        .bold()
                }
                .formSectionStyle()
                
                Section("Reminders") {
                    Toggle("Show reminders", isOn: $tvShow.reminderEnabled)
                        .toggleStyle(CheckToggleStyle())
                        .infoStyle()
                    
                    if tvShow.reminderEnabled {
                        DatePicker("Reminder date", selection: $tvShow.showReminderDate)
                            .tint(.darkRed)
                            .infoStyle()
                    }
                }
                .formSectionStyle()
                
#if os(iOS)
                Section(tvShow.showSeasons.count > 1 ? "Seasons" : "Season") {
                    TvShowSeasonsListView(tvShow: tvShow)
                }
                .formSectionStyle()
#endif
                
                Section("Informations") {
                    ItemMainInfoView(item: tvShow) {
                        TvShowInfoLabelsView(tvShow: tvShow)
                    }
                }
                .formSectionStyle()
                
                Section("Trailer") {
                    ItemTrailerView(item: tvShow)
                }
                .formSectionStyle()
                
                Section("Cast") {
                    ItemCastView(item: tvShow)
                        .frame(minHeight: 100)
                }
                .formSectionStyle()
            }
            .scrollContentBackground(.hidden)
            .onAppear {
                tvShow.watched = tvShow.numberOfEpisodesWatched == tvShow.numberOfEpisodes
            }
            .onChange(of: notificationViewModel.appError) { _, newError in
                if let error = newError {
                    errorManager.present(error)
                }
            }
            .onChange(of: tvShow.reminderEnabled) {
                Task {
                    await notificationViewModel.updateReminder()
                }
            }
            .onChange(of: tvShow.reminderDate) {
                Task {
                    await notificationViewModel.updateReminder()
                }
            }
        }
    }
}

#Preview {
    TvShowView(tvShow: .example, dataManager: DataManager.preview)
        .environmentObject(DataManager.preview)
}
