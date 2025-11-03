//
//  Extension-View.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 17/10/2025.
//

import SwiftUI

extension View {
    func overviewStyle() -> some View {
        modifier(Overview())
    }
    
    func infoStyle() -> some View {
        modifier(Informations())
    }
    
    func sectionTitleStyle() -> some View {
        modifier(SectionTitle())
    }
    
    func contentTitleStyle() -> some View {
        modifier(ContentTitle())
    }
    
    func inlineNavigationBar() -> some View {
        #if os(macOS)
        self
        #else
        self.navigationBarTitleDisplayMode(.inline)
        #endif
    }
}
