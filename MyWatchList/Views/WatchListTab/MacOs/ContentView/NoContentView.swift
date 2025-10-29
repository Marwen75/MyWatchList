//
//  NoContentView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 23/09/2025.
//

#if os(macOS)
import SwiftUI

struct NoContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.red.mix(with: .black, by: 0.5), .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            Text("No Content Selected")
                .font(.title)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NoContentView()
}
#endif
