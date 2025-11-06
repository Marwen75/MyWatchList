//
//  AppError.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 05/11/2025.
//

import Foundation

/// Represents all errors that can occur within the app.
enum AppError: LocalizedError, Equatable {
    case networkFailed
    case decodingFailed
    case databaseFailed
    case permissionDenied
    case invalidRequest
    case invalidURL
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .networkFailed:
            return NSLocalizedString("Unable to connect. Please check your internet connection.", comment: "")
        case .decodingFailed:
            return NSLocalizedString("We encountered a data error. Please try again later.", comment: "")
        case .databaseFailed:
            return NSLocalizedString("There was a problem accessing your saved items.", comment: "")
        case .permissionDenied:
            return NSLocalizedString("Permission denied. Please enable access in settings.", comment: "")
        case .invalidRequest:
            return NSLocalizedString("Something went wrong with the request. Please try again.", comment: "")
        case .invalidURL:
            return NSLocalizedString("The URL for the request is not valid. Please try again.", comment: "")
        case .unknown(_):
            return NSLocalizedString("An unexpected error occurred.", comment: "")
        }
    }
    
    var debugDescription: String {
        switch self {
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        default:
            return String(describing: self)
        }
    }
    
    static func == (lhs: AppError, rhs: AppError) -> Bool {
        lhs.errorDescription == rhs.errorDescription
    }
}

extension AppError {
    init(_ error: Error) {
        if let appError = error as? AppError {
            self = appError
        } else if (error as NSError).domain == NSURLErrorDomain {
            self = .networkFailed
        } else if error is DecodingError {
            self = .decodingFailed
        } else {
            self = .unknown(error)
        }
    }
}
