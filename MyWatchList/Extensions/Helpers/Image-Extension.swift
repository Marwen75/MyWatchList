//
//  Image-Extension.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 14/11/2025.
//

import SwiftUI

extension Image {
    @MainActor
    func asUIImage() -> UIImage {
        let renderer = ImageRenderer(content: self)
        return renderer.uiImage ?? UIImage()
    }
}
