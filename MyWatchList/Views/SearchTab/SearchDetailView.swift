//
//  SearchDetailView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import SwiftUI

struct SearchDetailView: View {
    @Environment(\.networkManager) var networkManager
    
    var jwContent: JustWatchContent
    @State private var imdbContent: ImdbContent?
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                AsyncImage(url: URL(string: jwContent.photoURL.first ?? "")) { poster in
                    poster
                        .image?.resizable()
                        .frame(height: 350)
                        .scaledToFit()
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Label("\(jwContent.year)", systemImage: "calendar")
                        Spacer()
                        Label(jwContent.type == .movie ? "Movie" : "TV Show", systemImage: jwContent.type == .movie ? "film" : "tv")
                    }
                    .font(.headline)
                    
                    HStack {
                        Label("\(jwContent.runtime) minutes", systemImage: "clock")
                        
                        Spacer()
                        
                        Label("\(jwContent.tomatoMeter ?? 0)/\(100)", systemImage: "star.circle")
                    }
                    .font(.headline)
                    
                    Spacer()
                    
                    Text("Actors: \(imdbContent?.actors ?? "N/A")")
                        .font(.subheadline)
                    
                }
                .padding()
                
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(jwContent.backdrops, id: \.self) { backDrop in
                            AsyncImage(url: URL(string: backDrop)) { image in
                                image.image?.resizable()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(5)
                            }
                        }
                        ForEach(jwContent.photoURL, id: \.self) { backDrop in
                            AsyncImage(url: URL(string: backDrop)) { image in
                                image.image?.resizable()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
                .padding()
                
                HStack {
                    Button("See on IMDB") {
                        UIApplication.shared.open(URL(string: "https://www.imdb.com/title/\(jwContent.imdbID ?? "")")!)
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Add to watchlist") {
                        
                    }
                    .buttonStyle(.bordered)
                }
            }
            .navigationTitle(jwContent.title)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                do {
                    let imdbResult = try await networkManager.fetch(.imdbResult, and: [URLQueryItem(name: "q", value: jwContent.imdbID ?? "")])
                    if let usableImdbContent = imdbResult.description.first {
                        imdbContent = usableImdbContent
                    }
                } catch {
                    print("Errorrrr sennnnnor")
                }
            }
        }
    }
}

#Preview {
    SearchDetailView(jwContent: JustWatchContent(id: "tm72398", type: .movie, url: "https://justwatch.com/in/movie/alien", title: "Alien", year: 1979, runtime: 117, photoURL: ["https://images.justwatch.com/poster/8543836/s592/alien.jpg", "https://images.justwatch.com/poster/8543836/s332/alien.jpg", "https://images.justwatch.com/poster/8543836/s166/alien.jpg"], backdrops: [], tmdbID: "348", imdbID: "", jwRating: 0.9705582182824707, tomatoMeter: nil, tomatoCertifiedFresh: nil, offers: []))
}
