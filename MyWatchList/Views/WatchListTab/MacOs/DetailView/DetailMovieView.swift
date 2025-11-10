//
//  DetailMovieView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 09/10/2025.
//
#if os(macOS)
import SwiftUI


struct DetailMovieView: View {
    @Environment(\.networkManager) var networkManager
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var movie: Movie
    @State private var shouldRefresh = false
    
    var body: some View {
        ScrollView {
            HStack {
                PosterImageView(path: movie.moviePoster, size: .flexible(maxWidth: 350, maxHeight: 500))
                    .onChange(of: movie) {
                        shouldRefresh.toggle()
                    }
                
                VStack {
                    ItemMainInfoView(item: movie) {
                        VStack(spacing: 10) {
                            CustomDivider()
                            
                            HStack {
                                Label("\(movie.movieReleaseDate)", systemImage: "calendar")
                                
                                Spacer()
                                
                                Label(movie.movieBudget == 0 ? "N/A" : "\(movie.movieBudget)", systemImage: "dollarsign.circle")
                            }
                            
                            CustomDivider()
                            
                            HStack {
                                Label("\(movie.movieRuntime, default: "N/A") minutes", systemImage: "clock")
                                
                                Spacer()
                                
                                Label(movie.movieVoteAverage == "0" ? "N/A" : movie.movieVoteAverage + "/10", systemImage: "star.circle")
                            }
                            
                            CustomDivider()
                        }
                    }
                    MoviePriorityAndTagView(movie: movie)
                    
                    CustomDivider()
                    
                    Toggle("Show reminders", isOn: $movie.reminderEnabled)
                        .toggleStyle(CheckToggleStyle())
                        .infoStyle()
                        .padding()
                    
                    if movie.reminderEnabled {
                        DatePicker("Reminder date", selection: $movie.movieReminderDate)
                            .tint(.darkRed)
                            .infoStyle()
                        
                    }
                }
            }
            .padding()
            
            CustomDivider()
                .padding()
            
            ItemTrailerView(item: movie)
                    .padding()
                    .id(shouldRefresh)
            
            CustomDivider()
                .padding()
            
            ItemCastView(item: movie)
                .padding()
            
            CustomDivider()
                .padding()
            
            Button {
                movie.watched.toggle()
            } label: {
                Text(movie.watched ? "Mark as unwatched" : "Mark as watched")
            }
            .frame(width: 200, height: 150)
            .padding()
            .buttonStyle(.borderedProminent)
            .tint(movie.watched ? Color.darkGreen : Color.darkYellow)
        }
        .background(.linearGradient(colors: [.darkRed, .black], startPoint: .top, endPoint: .bottom))
    }
}

#Preview {
    DetailMovieView(movie: .example)
        .environmentObject(DataManager.preview)
}
#endif
