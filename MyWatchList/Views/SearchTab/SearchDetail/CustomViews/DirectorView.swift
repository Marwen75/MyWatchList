//
//  DirectorView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 10/09/2025.
//

import SwiftUI

struct DirectorView: View {
    @ObservedObject var searchDetailViewModel: SearchDetailViewModel
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(searchDetailViewModel.directors) { director in
                    if let profilePath = director.profilePath {
                        PersonImageView(width: 50, height: 50, profilePath: profilePath)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .background {
                                Circle().stroke(.yellow.mix(with: .black, by: 0.1), lineWidth: 1)
                            }
                            .shadow(color: .white, radius: 2)
                    }
                    
                    Text(director.name)
                        .infoStyle()
                    
                    Spacer()
                }
            }
        }
        .scrollDisabled(searchDetailViewModel.directors.count <= 1)
        .safeAreaPadding([.leading, .top, .bottom], 10)
    }
}

#Preview {
    DirectorView(searchDetailViewModel: SearchDetailViewModel(dataManager: DataManager.preview, networkManager: NetworkManager(environment: .testing), tmdbId: 1409, typeOfContent: .shows))
}
