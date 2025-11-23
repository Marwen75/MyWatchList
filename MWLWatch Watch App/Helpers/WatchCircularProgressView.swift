//
//  WatchCircularProgressView.swift
//  MWLWatch Watch App
//
//  Created by Marwen Haouacine on 22/11/2025.
//

import SwiftUI

struct WatchCircularProgressView: View {
    let progress: Double
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .foregroundStyle(.white.opacity(0.2))
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .foregroundStyle(.yellow)
                .animation(.easeInOut(duration: 0.3), value: progress)
            
            Text("\(Int(progress * 100))%")
                .font(.footnote)
                .fontDesign(.monospaced)
                .foregroundStyle(.white.opacity(0.9))
            
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    WatchCircularProgressView(progress: 0.3, width: 32, height: 32)
}
