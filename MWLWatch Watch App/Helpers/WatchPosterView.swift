//
//  WatchPosterView.swift
//  MWLWatch Watch App
//
//  Created by Marwen Haouacine on 22/11/2025.
//

import SwiftUI

struct WatchPosterView: View {
    let posterPath: String

    var body: some View {
        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w154\(posterPath)")) { phase in
            switch phase {
            case .empty:
                ProgressView()

            case .success(let image):
                image
                    .resizable()
                    .frame(width: 90, height: 120)
                    .scaledToFit()
                    .cornerRadius(6)
                    .shadow(color: .darkYellow, radius: 3)

            case .failure:
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white.opacity(0.2))
                    .frame(height: 120)
                    .overlay(
                        Image(systemName: "film")
                            .font(.largeTitle)
                            .foregroundStyle(.white.opacity(0.5))
                    )

            @unknown default:
                EmptyView()
            }
        }
    }
}


#Preview {
    WatchPosterView(posterPath: "/7WsyChQLEftFiDOVTGkv3hFpyyt.jpg")
}
