//
//  ItemCastView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 05/11/2025.
//

import SwiftUI

struct ItemCastView<T:WatchableItem>: View {
    @ObservedObject var item: T
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .top, spacing: 12) {
                ForEach(item.itemActors) { actor in
                    VStack {
                        if !actor.actorPicture.isEmpty {
                            PosterImageView(path: actor.actorPicture, shape: .circle,
                                            size: .fixed(width: 100, height: 100), contentMode: .fill)
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .background {
                                    Circle().stroke(Color.darkYellow, lineWidth: 1)
                                }
                                .shadow(color: .white, radius: 3)
                        }
                        
                        Text(actor.actorName)
                            .infoStyle()
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                            .truncationMode(.tail)
                            .frame(width: 100)
                    }
                    .frame(width: 120)
                }
            }
        }
        .safeAreaPadding([.leading, .top, .trailing], 10)
    }
}

#Preview {
    ItemCastView(item: Movie.example)
}
