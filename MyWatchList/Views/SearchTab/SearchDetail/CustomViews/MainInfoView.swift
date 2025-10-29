//
//  MainInfoView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 08/09/2025.
//

import SwiftUI

struct MainInfoView: View {
    @ObservedObject var searchDetailViewModel: SearchDetailViewModel
    
    var body: some View {
#if os(macOS)
        VStack {
            if searchDetailViewModel.typeOfContent == .movies {
                if !searchDetailViewModel.directors.isEmpty {
                    VStack(alignment: .leading) {
                        Label(searchDetailViewModel.directors.count > 1 ? "Directors" : "Director", systemImage: "person.crop.square.badge.video")
                            .infoStyle()
                        
                        DirectorView(searchDetailViewModel: searchDetailViewModel)
                    }
                }
            } else {
                if !searchDetailViewModel.creators.isEmpty {
                    VStack(alignment: .leading) {
                        Label(searchDetailViewModel.creators.count > 1 ? "Creators" : "Creator", systemImage: "rectangle.and.pencil.and.ellipsis")
                            .infoStyle()
                        
                        CreatorView(searchDetailViewModel: searchDetailViewModel)
                    }
                }
            }
            
            CustomDivider()
                .padding()
            
            HStack {
                Label(searchDetailViewModel.typeOfContent == .movies ? "\(searchDetailViewModel.tmdbContent?.releaseDate ?? "N/A")" : "\(searchDetailViewModel.tmdbContent?.firstAirDate ?? "N/A")", systemImage: "calendar")
                Spacer()
                if searchDetailViewModel.typeOfContent == .shows  {
                    if let inProduction = searchDetailViewModel.tmdbContent?.inProduction {
                        if inProduction {
                            Label("In production", systemImage: "video")
                        } else {
                            Label(searchDetailViewModel.tmdbContent?.lastAirDate ?? "N/A", systemImage: "video.slash")
                        }
                    }
                } else {
                    Label(searchDetailViewModel.tmdbContent?.budget == nil ? "N/A" : "\(searchDetailViewModel.tmdbContent?.budget, default: "N/A")", systemImage: "dollarsign.circle")
                }
            }
            .infoStyle()
            
            CustomDivider()
                .padding()
            
            HStack {
                Label(searchDetailViewModel.typeOfContent == .movies ? "\(searchDetailViewModel.tmdbContent?.runtime, default: "N/A") minutes" : "\(searchDetailViewModel.tmdbContent?.numberOfEpisodes, default: "N/A") episodes", systemImage: "clock")
                
                Spacer()
                
                Label(searchDetailViewModel.tmdbContent?.voteAverage == nil ? "N/A" : String(format: "%.1f", searchDetailViewModel.tmdbContent?.voteAverage ?? 0) + "/10", systemImage: "star.circle")
            }
            .infoStyle()
            
            CustomDivider()
                .padding()
            
            if let genres = searchDetailViewModel.tmdbContent?.genres {
                HStack {
                    Text(genres.map(\.self.name).joined(separator: ", "))
                        .infoStyle()
                    Spacer()
                }
                .padding(.leading, 5)
            }
            
            CustomDivider()
                .padding()
            
            Text(searchDetailViewModel.tmdbContent?.overview ?? "N/A")
                .overviewStyle()
        }
#else
        if searchDetailViewModel.typeOfContent == .movies {
            if !searchDetailViewModel.directors.isEmpty {
                VStack(alignment: .leading) {
                    Label(searchDetailViewModel.directors.count > 1 ? "Directors" : "Director", systemImage: "person.crop.square.badge.video")
                        .infoStyle()
                    
                    DirectorView(searchDetailViewModel: searchDetailViewModel)
                }
            }
        } else {
            if !searchDetailViewModel.creators.isEmpty {
                VStack(alignment: .leading) {
                    Label(searchDetailViewModel.creators.count > 1 ? "Creators" : "Creator", systemImage: "rectangle.and.pencil.and.ellipsis")
                        .infoStyle()
                    
                    CreatorView(searchDetailViewModel: searchDetailViewModel)
                }
            }
        }
        HStack {
            Label(searchDetailViewModel.typeOfContent == .movies ? "\(searchDetailViewModel.tmdbContent?.releaseDate ?? "N/A")" : "\(searchDetailViewModel.tmdbContent?.firstAirDate ?? "N/A")", systemImage: "calendar")
            Spacer()
            if searchDetailViewModel.typeOfContent == .shows  {
                if let inProduction = searchDetailViewModel.tmdbContent?.inProduction {
                    if inProduction {
                        Label("In production", systemImage: "video")
                    } else {
                        Label(searchDetailViewModel.tmdbContent?.lastAirDate ?? "N/A", systemImage: "video.slash")
                    }
                }
            } else {
                Label(searchDetailViewModel.tmdbContent?.budget == nil ? "N/A" : "\(searchDetailViewModel.tmdbContent?.budget, default: "N/A")", systemImage: "dollarsign.circle")
            }
        }
        .infoStyle()
        
        HStack {
            Label(searchDetailViewModel.typeOfContent == .movies ? "\(searchDetailViewModel.tmdbContent?.runtime, default: "N/A") minutes" : "\(searchDetailViewModel.tmdbContent?.numberOfEpisodes, default: "N/A") episodes", systemImage: "clock")
            
            Spacer()
            
            Label(searchDetailViewModel.tmdbContent?.voteAverage == nil ? "N/A" : String(format: "%.1f", searchDetailViewModel.tmdbContent?.voteAverage ?? 0) + "/10", systemImage: "star.circle")
        }
        .infoStyle()
        
        if let genres = searchDetailViewModel.tmdbContent?.genres {
            VStack(alignment: .center, spacing: 10) {
                HStack {
                    Text(genres.map(\.self.name).joined(separator: ", "))
                        .infoStyle()
                }
            }
            .infoStyle()
        }
        
        Text(searchDetailViewModel.tmdbContent?.overview ?? "N/A")
            .overviewStyle()
#endif
    }
}

#Preview {
    MainInfoView(searchDetailViewModel: SearchDetailViewModel(dataManager: DataManager.preview, networkManager: NetworkManager(environment: .testing), tmdbId: 1409, typeOfContent: .shows))
}
