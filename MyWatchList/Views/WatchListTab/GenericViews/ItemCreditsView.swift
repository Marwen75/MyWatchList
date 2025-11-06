//
//  ItemCreditsView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 05/11/2025.
//

import SwiftUI

/// A generic director or creator list view for any WatchableItem
struct ItemCreditsView<T: WatchableItem>: View {
    @ObservedObject var item: T
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(item.itemCredits) { director in
                    HStack {
                        if !director.directorPicture.isEmpty {
                            PosterImageView(path: director.directorPicture, shape: .circle,
                                size: .fixed(width: 50, height: 50), contentMode: .fill)
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .background {
                                    Circle().stroke(Color.darkYellow, lineWidth: 1)
                                }
                                .shadow(color: .white, radius: 3)
                        }
                        
                        Text(director.directorName)
                            .infoStyle()
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
        .scrollDisabled(item.itemCredits.count <= 1)
        .safeAreaPadding([.leading, .top, .bottom], 10)
    }
}

#Preview {
    ItemCreditsView(item: Movie.example)
}
