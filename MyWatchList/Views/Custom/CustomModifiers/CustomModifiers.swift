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
            .font(.system(size: 15, weight: .thin, design: .serif)).italic()
    }
}

struct Informations: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 15, weight: .light, design: .serif))
            .foregroundStyle(.primary)
    }
}

struct SectionTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17, weight: .bold, design: .monospaced))
    }
}

struct ContentTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .semibold, design: .monospaced))
    }
}
