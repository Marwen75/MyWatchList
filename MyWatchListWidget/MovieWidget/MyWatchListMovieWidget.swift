//
//  MyWatchListMovieWidget.swift
//  MyWatchListWidgetExtension
//
//  Created by Marwen Haouacine on 13/11/2025.
//

import WidgetKit
import SwiftUI
import CoreData

// MARK: - Provider

struct MovieProvider: TimelineProvider {
    func placeholder(in context: Context) -> MovieWidgetEntry {
        MovieWidgetEntry(date: .now, movies: [WidgetMovie(objectID: .init(), id: "preview", title: "Oppenheimer", tags: "Watch urgently", image: nil)])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MovieWidgetEntry) -> ()) {
        let entry = MovieWidgetEntry(date: .now, movies: loadMovies())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = MovieWidgetEntry(date: .now, movies: loadMovies())
        completion(Timeline(entries: [entry], policy: .never))
    }
    
    private func loadMovies() -> [WidgetMovie] {
        let dataManager = DataManager()
        let request = dataManager.fetchRequestForTopMovies(count: 2)
        let movies = dataManager.results(for: request)
        return movies.map {
            WidgetMovie(objectID: $0.objectID, id: "\($0.movieId)", title: $0.movieTitle, tags: $0.movieTagsList,
                        image: ImageCacheManager.loadImageFromSharedContainer(for: "Movie_\($0.movieId)"))
        }
    }
}

// MARK: - Entry

struct MovieWidgetEntry: TimelineEntry {
    let date: Date
    let movies: [WidgetMovie]
}

// MARK: - Entry View

struct MyWatchListMovieWidgetEntryView: View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: MovieWidgetEntry
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            if let movie = entry.movies.first {
                SmallMovieWidgetView(movie: movie)
            } else {
                EmptyWidgetView()
            }
        case .systemMedium:
            if let movie = entry.movies.first {
                MediumMovieWidgetView(movie: movie)
            } else {
                EmptyWidgetView()
            }
        case .systemLarge:
            LargeMovieWidgetView(movies: entry.movies)
        default:
            EmptyWidgetView()
        }
    }
}

// MARK: - Widget

struct MyWatchListMovieWidget: Widget {
    let kind: String = "MyWatchListWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MovieProvider()) { entry in
            MyWatchListMovieWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Next on your watch list")
        .description("Immersive cinematic previews from your watchlist.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

#Preview(as: .systemMedium) {
    MyWatchListMovieWidget()
} timeline: {
    MovieWidgetEntry(date: .now, movies: [WidgetMovie(objectID: NSManagedObjectID(), id: "preview", title: "Alien: Romulus", tags: "With the wifey", image: nil)])
}
