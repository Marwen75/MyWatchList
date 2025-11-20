//
//  ImageCacheTests.swift
//  MyWatchListTests
//
//  Created by Marwen Haouacine on 20/11/2025.
//

import XCTest
@testable import MyWatchList
import UIKit

final class ImageCacheTests: MyWatchListBaseTestCase {
    private var mockFM: MockFileManager!
    private let testRoot = URL(fileURLWithPath: "/mock-root")

    override func setUp() {
        super.setUp()
        mockFM = MockFileManager()

        ImageCacheManager.fileManager = mockFM
        ImageCacheManager.containerURLProvider = { URL(fileURLWithPath: "/mock-root") }
    }

    override func tearDown() {
        mockFM = nil
        super.tearDown()
    }
    
    // MARK: - Helpers
    
    private func createTestImage() -> UIImage {
        // A simple 1x1 image for consistent encoding
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIColor.red.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    // MARK: - Tests

    func testsavingImageShouldCreateFile() {
        let image = createTestImage()
        let id = "123"

        ImageCacheManager.saveImageToSharedContainer(image, for: id)

        XCTAssertNotNil(mockFM.files["/mock-root/123.jpg"])
    }

    func testSavingImageShouldNotOverwriteExistingImage() {
        let image = createTestImage()
        let id = "999"

        ImageCacheManager.saveImageToSharedContainer(image, for: id)
        let initialData = mockFM.files["/mock-root/999.jpg"]

        // Try saving again → should NOT overwrite
        ImageCacheManager.saveImageToSharedContainer(image, for: id)

        XCTAssertEqual(mockFM.files["/mock-root/999.jpg"], initialData)
    }

    func testLoadingImageShouldReturnImageIfImageExists() {
        let id = "photo"

        let image = createTestImage()
        let jpeg = image.jpegData(compressionQuality: 0.8)!

        mockFM.files["/mock-root/photo.jpg"] = jpeg

        let loaded = ImageCacheManager.loadImageFromSharedContainer(for: id)

        XCTAssertNotNil(loaded)
        XCTAssertEqual(loaded!.size.width, 1)
        XCTAssertEqual(loaded!.size.height, 1)
    }

    func testLoadingImageShouldReturnNilIfNotFound() {
        let result = ImageCacheManager.loadImageFromSharedContainer(for: "ghost")
        XCTAssertNil(result)
    }

    func tesDeletingImageShouldRemoveFile() {
        let id = "delete-me"

        // Simulate existing file
        mockFM.files["/mock-root/delete-me.jpg"] = Data([1,2,3])

        ImageCacheManager.deleteImageFromSharedContainer(for: id)

        XCTAssertNil(mockFM.files["/mock-root/delete-me.jpg"])
    }

    func testSavingImageDoesNothingIfContainerURLUnavailable() {
        mockFM.containerURLToReturn = nil
        
        ImageCacheManager.containerURLProvider = { [weak self] in
            self?.mockFM.containerURLToReturn
        }

        let image = createTestImage()
        ImageCacheManager.saveImageToSharedContainer(image, for: "shouldNotSave")

        XCTAssertTrue(mockFM.files.isEmpty)
    }

    func testLoadingImageShouldReturnNilIfContainerURLUnavailable() {
        mockFM.containerURLToReturn = nil

        let result = ImageCacheManager.loadImageFromSharedContainer(for: "whatever")

        XCTAssertNil(result)
    }
}
