//
//  SearchView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 29/08/2025.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.networkManager) var networkManager
    
    @State private var searchText = ""
    @State private var contents: [ImdbContent] = []
    @State private var jwContents: [JustWatchContent] = []
    @State private var errorMessage = ""
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            
            TextField("Search", text: $searchText, prompt: Text("Search for a movie or a show"))
                .padding()
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    Task {
                        try await search(with: searchText)
                    }
                }
            
            List {
                Section("Results") {
                    ForEach(jwContents) { content in
                        NavigationLink {
                            SearchDetailView(jwContent: content)
                        } label: {
                            VStack(alignment: .center) {
                                Text(content.title)
                                    .font(.headline)
                                
                                HStack {
                                    Spacer()
                                    
                                    AsyncImage(url: URL(string: content.photoURL.first ?? "")) { poster in
                                        poster
                                            .image?.resizable()
                                            .frame(width: 300, height: 300)
                                            .cornerRadius(5)
                                    }
                                    
                                    Spacer()
                                }
                                
                                Text(content.type == .show ? "TV Show" : "Movie")
                                    .font(.subheadline)
                                
                                //Text(String(content.year ?? 0))
                                    //.font(.caption)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search")
        }
    }
    
    func search(with text: String) async throws {
        do {
            let justWatchResult = try await networkManager.fetch(.justWatchResult, and: [URLQueryItem(name: "q", value: text)])
            jwContents = justWatchResult.description
        } catch {
            errorMessage = error.localizedDescription
            showAlert = true
            print(networkManager.environment.session)
            print("Error handling is a smart move! \(error.localizedDescription)")
        }
    }
}

#Preview {
    SearchView()
}
