//
//  MovieView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 23/09/2025.
//

import SwiftUI

struct MovieView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var errorManager: ErrorManager
    @StateObject private var notificationViewModel: NotificationViewModel<Movie>
    @ObservedObject var movie: Movie
    
    init(movie: Movie, dataManager: DataManager) {
        self.movie = movie
        let viewModel = NotificationViewModel(item: movie, dataManager: dataManager)
        _notificationViewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.darkRed, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            Form {
                Section(movie.movieTitle) {
                    PosterImageView(path: movie.moviePoster, size: .flexible(maxHeight: 700))
                    
                    MoviePriorityAndTagView(movie: movie)
                        .infoStyle()
                }
                .formSectionStyle()
                
                Section("Reminders") {
                    Toggle("Show reminders", isOn: $movie.reminderEnabled)
                        .toggleStyle(CheckToggleStyle())
                        .infoStyle()
                    
                    if movie.reminderEnabled {
                        DatePicker("Reminder date", selection: $movie.movieReminderDate)
                            .tint(.darkRed)
                            .infoStyle()
                    }
                }
                .formSectionStyle()
                
                Section("Informations") {
                    ItemMainInfoView(item: movie) {
                        HStack {
                            Label("\(movie.movieReleaseDate)", systemImage: "calendar")
                            Spacer()
                            Label(movie.movieBudget == 0 ? "N/A" : "\(movie.movieBudget)", systemImage: "dollarsign.circle")
                        }
                        .infoStyle()
                        
                        HStack {
                            Label("\(movie.movieRuntime, default: "N/A") minutes", systemImage: "clock")
                            Spacer()
                            Label(movie.movieVoteAverage == "0" ? "N/A" : movie.movieVoteAverage + "/10", systemImage: "star.circle")
                        }
                        .infoStyle()
                    }
                }
                .formSectionStyle()
                
                Section("Trailer") {
                    ItemTrailerView(item: movie)
                }
                .formSectionStyle()
                
                Section("Cast") {
                    ItemCastView(item: movie)
                        .frame(minHeight: 100)
                }
                .formSectionStyle()
            }
            .scrollContentBackground(.hidden)
            .onChange(of: notificationViewModel.appError) { _, newError in
                if let error = newError {
                    errorManager.present(error)
                }
            }
            .onChange(of: movie.reminderEnabled) {
                Task {
                    await notificationViewModel.updateReminder()
                }
            }
            .onChange(of: movie.reminderDate) {
                Task {
                    await notificationViewModel.updateReminder()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieView(movie: .example, dataManager: DataManager.preview)
            .environmentObject(DataManager.preview)
    }
}
