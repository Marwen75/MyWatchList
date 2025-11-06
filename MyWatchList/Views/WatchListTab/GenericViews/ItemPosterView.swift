//
//  ItemPosterView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 05/11/2025.
//

import SwiftUI

struct ItemPosterView<T: WatchableItem>: View {
    let item: T
    
    var body: some View {
        PosterImageView(path: item.itemPosterPath, size: .flexible(maxHeight: 650))
    }
}

#Preview {
    ItemPosterView(item: Movie.example)
}
