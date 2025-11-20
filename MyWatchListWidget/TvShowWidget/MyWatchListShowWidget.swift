//
//  MyWatchListShowWidget.swift
//  MyWatchListWidgetExtension
//
//  Created by Marwen Haouacine on 14/11/2025.
//

import WidgetKit
import SwiftUI
import CoreData

// MARK: - Provider

struct TvShowProvider: TimelineProvider {
    func placeholder(in context: Context) -> TvShowEntry {
        TvShowEntry(date: .now, shows: [WidgetShow(objectID: .init(), id: "preview", title: "Breaking Bad", seasonNumber: 4, episodeNumber: 2, episodeTitle: "Thirty-Eight Snub", progress: 0.45, image: nil)])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TvShowEntry) -> ()) {
        completion(TvShowEntry(date: .now, shows: loadShows()))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<TvShowEntry>) -> ()) {
        let entry = TvShowEntry(date: .now, shows: loadShows())
        completion(Timeline(entries: [entry], policy: .never))
    }
    
    func loadShows() -> [WidgetShow] {
        let dataManager = DataManager()
        let request = dataManager.fetchRequestForTopTvShows(count: 2)
        let shows = dataManager.results(for: request)
        
        var result: [WidgetShow] = []
        
        for show in shows {
            let next = show.nextUnwatchedEpisode()
            
            guard let next else { continue }
            
            let widgetShow = WidgetShow(
                objectID: show.objectID, id: "show_\(show.showId)",
                title: show.showTitle, seasonNumber: Int(next.season?.seasonNumber ?? 0),
                episodeNumber: Int(next.episodeNumber), episodeTitle: next.episodeName, progress: next.season?.seasonProgress ?? 0,
                image: ImageCacheManager.loadImageFromSharedContainer(for: "TvShow_\(show.showId)")
            )
            
            result.append(widgetShow)
        }
        
        return result
    }
}

// MARK: - Entry

struct TvShowEntry: TimelineEntry {
    let date: Date
    let shows: [WidgetShow]
}

// MARK: - Entry View

struct TvShowWidgetEntryView: View {
    @Environment(\.widgetFamily) var widgetFamily
    let entry: TvShowEntry
    
    var body: some View {
        if entry.shows.isEmpty {
            EmptyWidgetView()
        } else {
            switch widgetFamily {
            case .systemSmall:
                if let first = entry.shows.first {
                    SmallShowWidgetView(show: first)
                } else {
                    EmptyWidgetView()
                }
            case .systemMedium:
                if let first = entry.shows.first {
                    MediumShowWidgetView(show: first)
                } else {
                    EmptyWidgetView()
                }
            case .systemLarge:
                LargeShowWidgetView(shows: entry.shows)
            default:
                EmptyWidgetView()
            }
        }
    }
}

// MARK: - Widget

struct MyWatchListShowWidget: Widget {
    let kind = "MyWatchListShowWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TvShowProvider()) { entry in
            TvShowWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Continue Watching")
        .description("See your next episodes and your progression.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

#Preview(as: .systemMedium) {
    MyWatchListShowWidget()
} timeline: {
    TvShowEntry(date: .now, shows: [WidgetShow(objectID: NSManagedObjectID(), id: "preview", title: "Breaking Bad", seasonNumber: 4, episodeNumber: 2, episodeTitle: "Thirty-Eight Snub", progress: 0.45, image: nil)])
}

