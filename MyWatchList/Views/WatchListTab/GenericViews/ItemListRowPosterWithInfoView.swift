//
//  ItemListRowPosterWithInfoView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 07/11/2025.
//

import SwiftUI

struct ItemListRowPosterWithInfoView<T: WatchableItem>: View {
    @ObservedObject var item: T
    
    private var priorityLabel: (text: String, icon: String) {
        switch item.itemPriority {
        case 0:
            return (item.itemWatched ? NSLocalizedString("Re-watch eventually", comment: "") : NSLocalizedString("Watch later", comment: ""), "eye.half.closed")
        case 1:
            return (item.itemWatched ? NSLocalizedString("Re-watch soon", comment: "") : NSLocalizedString("Must watch", comment: ""), "eye")
        default:
            return (item.itemWatched ? NSLocalizedString("Re-watch urgently" , comment: ""): NSLocalizedString("Watch urgently", comment: ""), "eye.trianglebadge.exclamationmark")
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            PosterImageView(path: item.itemPosterPath, size: .flexible(maxHeight: 700, minHeight: 150), cacheIdentifier: item.cacheIdentifier)
            
            VStack {
                HStack {
                    Label(item.itemTagsList, systemImage: "tag")
                        .padding(10)
                        .background(Color.badgeBackground)
                        .cornerRadius(20)
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    Label(priorityLabel.text, systemImage: priorityLabel.icon)
                        .padding(10)
                        .background(Color.badgeBackground)
                        .cornerRadius(20)
                    
                    Spacer()
                }
            }
            .font(.system(size: 11, weight: .black, design: .rounded))
            .foregroundStyle(.white)
            .fontWidth(.condensed)
            .padding(5)
        }
    }
}

#Preview {
    ItemListRowPosterWithInfoView(item: Movie.example)
}
