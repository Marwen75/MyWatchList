//
//  CustomModifiers.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 17/10/2025.
//

import SwiftUI

struct Overview: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14, weight: .light, design: .monospaced))
            .fontWidth(.condensed)
            .foregroundStyle(.white)
    }
}

struct Informations: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 15, weight: .light, design: .monospaced))
            .fontWidth(.condensed)
            .foregroundStyle(.white)
    }
}

struct SectionTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17, weight: .bold, design: .monospaced))
            .foregroundStyle(.gray)
    }
}

struct ContentTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .semibold, design: .monospaced))
            .foregroundStyle(.white)
    }
}

struct FormSection: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowBackground(Color.darkYellow.opacity(0.1))
            .sectionTitleStyle()
    }
}

struct SizeModifier: ViewModifier {
    let size: PosterImageView.PosterSize
    
    func body(content: Content) -> some View {
        switch size {
        case .fixed(let width, let height):
            content.frame(width: width, height: height)
        case .flexible(let maxWidth, let maxHeight, let minHeight):
            content.frame(maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight)
        }
    }
}

struct ShapeModifier: ViewModifier {
    let shape: PosterImageView.PosterShape
    
    func body(content: Content) -> some View {
        switch shape {
        case .rounded(let radius):
            content
                .cornerRadius(radius)
                .background { RoundedRectangle(cornerRadius: radius).stroke(Color.darkYellow, lineWidth: 1) }
        case .circle:
            content
                .clipShape(Circle())
                .background { Circle().stroke(Color.darkYellow, lineWidth: 1) }
        }
    }
}
