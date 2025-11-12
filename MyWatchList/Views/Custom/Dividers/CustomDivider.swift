//
//  CustomDivider.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 08/09/2025.
//

import SwiftUI

struct CustomDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(.yellow.mix(with: .black, by: 0.1))
    }
}

#Preview {
    CustomDivider()
}
