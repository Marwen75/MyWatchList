//
//  ContentViewTvShowRow.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 09/10/2025.
//

#if os(macOS)
import SwiftUI

struct ContentViewTvShowRow: View {
    @Environment(\.networkManager) var networkManager
    @ObservedObject var tvShow: TvShow
    
    var body: some View {
        VStack {
            Text(tvShow.showTitle)
            Label(tvShow.showTagsList, systemImage: "tag")
            
            HStack {
                Spacer()
                SmallPosterImageView(maxWidth: 150, maxHeight: 200, path: tvShow.showPoster)
                Spacer()
            }
            
            HStack {
                switch tvShow.priority {
                case 0:
                    Label("Watch later", systemImage: "eye.half.closed")
                        .imageScale(.small)
                case 1:
                    Label("Must see", systemImage: "eye")
                        .imageScale(.small)
                default:
                    Label("See urgently", systemImage: "eye.trianglebadge.exclamationmark")
                        .imageScale(.small)
                }
            }
        }
        .padding(3)
        .infoStyle()
    }
}

#Preview {
    ContentViewTvShowRow(tvShow: .example)
}
#endif
