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
                PosterImageView(path: tvShow.showPoster, size: .flexible(maxWidth: 150, maxHeight: 200))
                Spacer()
            }
            
            HStack {
                switch tvShow.priority {
                case 0:
                    Label("Watch later", systemImage: "eye.half.closed")
                        .imageScale(.small)
                case 1:
                    Label("Must watch", systemImage: "eye")
                        .imageScale(.small)
                default:
                    Label("Watch urgently", systemImage: "eye.trianglebadge.exclamationmark")
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
