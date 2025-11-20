//
//  ImageCacheManager.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 14/11/2025.
//

import UIKit

/// A utility responsible for storing and retrieving images inside the app group's
/// shared container. This is primarily used to make image data accessible across
/// multiple app targets (e.g., main app + widgets).
/// Images are saved using a unique identifier as filename with a `.jpg` extension.
struct ImageCacheManager {
    
    /// The identifier of the App Group used to share files between the main app
    /// and its extensions (e.g., widgets).
    static let appGroupID = "group.com.marwen.MyWatchList"
    
    // MARK: - Testable dependencies (overridable in tests)
    
    /// File manager used for all file operations.
    /// In production: `FileManager.default`.
    /// In tests: can be replaced by a `MockFileManager`.
    static var fileManager: FileManaging = FileManager.default
    
    /// Provides the root URL where images are stored.
    /// In production: App Group container URL.
    /// In tests: peut être remplacé par un dossier temporaire.
    static var containerURLProvider: () -> URL? = {
        fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)
    }
    
    /// Saves a JPEG-compressed representation of the provided image into the shared
    /// App Group container, using the given identifier as the filename.
    /// If a file already exists for this identifier, the function does nothing
    /// to avoid unnecessary disk writes.
    /// - Parameters:
    ///   - image: The `UIImage` to persist.
    ///   - identifier: A unique string used to name the stored file
    static func saveImageToSharedContainer(_ image: UIImage, for identifier: String) {
        guard let containerURL = containerURLProvider() else { return }
        
        let imageURL = containerURL.appendingPathComponent("\(identifier).jpg")
        
        // Prevent overwriting an existing file unnecessarily
        if fileManager.fileExists(atPath: imageURL.path) { return }
        
        // Compress and write image to disk
        if let data = image.jpegData(compressionQuality: 0.8) {
            try? fileManager.writeFile(data: data, to: imageURL)
        }
    }
    
    /// Loads a previously saved image from the shared App Group container.
    /// - Parameter identifier: The unique identifier used when the image was saved.
    /// - Returns: A `UIImage` if the file exists and can be decoded, otherwise `nil`.
    static func loadImageFromSharedContainer(for identifier: String) -> UIImage? {
        guard let containerURL = containerURLProvider() else { return nil }
        
        let imageURL = containerURL.appendingPathComponent("\(identifier).jpg")
        
        // Ensure file really exists
        guard fileManager.fileExists(atPath: imageURL.path) else { return nil }
        
        if let data = fileManager.contents(atPath: imageURL.path) {
            return UIImage(data: data)
        }

        return nil
    }
    
    /// Deletes a cached image, if it exists, for the given identifier.
    static func deleteImageFromSharedContainer(for identifier: String) {
        guard let containerURL = containerURLProvider() else { return }
        
        let imageURL = containerURL.appendingPathComponent("\(identifier).jpg")
        try? fileManager.removeItem(at: imageURL)
    }
}
