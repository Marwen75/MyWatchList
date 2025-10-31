//
//  PosterView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 09/09/2025.
//

import SwiftUI

struct PosterView: View {
    @ObservedObject var searchDetailViewModel: SearchDetailViewModel
    
    var body: some View {
        if let tmdbContent = searchDetailViewModel.tmdbContent, let posterPath = tmdbContent.posterPath {
            PosterImageView(path: posterPath, size: .flexible(maxHeight: 650))
        } else {
            ContentUnavailableView("No Poster Available", systemImage: "film")
        }
    }
}

#Preview {
    PosterView(searchDetailViewModel: SearchDetailViewModel(dataManager: DataManager.preview, networkManager: NetworkManager(environment: .testing), tmdbId: 1409, typeOfContent: .shows))
}
