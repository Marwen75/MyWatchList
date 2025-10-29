//
//  JsonResponse.swift
//  MyWatchListTests
//
//  Created by Marwen Haouacine on 20/10/2025.
//

import Foundation

enum JsonResponse: String {
    case searchMovie = "SearchMovieResponse"
    case searcnTvShow = "SearchTvShowResponse"
    case movieDetails = "MovieDetailsResponse"
    case tvShowDetails = "TvShowDetailsResponse"
    case movieCredits = "MovieCreditsResponse"
    case tvShowCredits = "TvShowCreditsResponse"
    case seasonDetails = "SeasonDetailsResponse"
    case error = "oups"
}
