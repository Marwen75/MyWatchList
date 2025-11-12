//
//  SegmentedPickerView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 10/11/2025.
//

import SwiftUI

struct SegmentedPickerView<T: Hashable>: View {
    @Binding var selection: T
    let items: [T]
    let label: (T) -> String
    let icon: ((T) -> String?)?

    @Namespace private var animation
    private let cornerRadius: CGFloat = 22

    var body: some View {
        HStack(spacing: 6) {
            ForEach(items, id: \.self) { item in
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        selection = item
                    }
                } label: {
                    HStack(spacing: 4) {
                        if let iconName = icon?(item) {
                            Image(systemName: iconName)
                                .font(.system(size: 14, weight: .medium))
                        }

                        Text(label(item))
                            .infoStyle()
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(
                        ZStack {
                            if selection == item {
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .fill(Color.yellow.mix(with: .black, by: 0.1))
                                    .matchedGeometryEffect(id: "highlight", in: animation)
                                    .shadow(color: .yellow.opacity(0.25), radius: 6, y: 3)
                            }
                        }
                    )
                    .foregroundStyle(selection == item ? Color.darkRed : .white.opacity(0.85))
                    .scaleEffect(selection == item ? 1.05 : 1.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selection)
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("segmentedButton_\(String(describing: item))")
            }
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(LinearGradient(colors: [.black.opacity(0.6), .darkRed.opacity(0.4)],
                                     startPoint:.topLeading, endPoint: .bottomTrailing))
                .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(Color.white.opacity(0.15), lineWidth: 1))
                .shadow(color: .black.opacity(0.5), radius: 6, y: 3)
        )
        .padding(.horizontal)
        .frame(maxWidth: 350)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    struct PreviewWrapper: View {
        enum DemoType: String, CaseIterable, Hashable {
            case movies = "Films"
            case shows = "Séries"
        }

        @State private var selected: DemoType = .movies

        var body: some View {
            VStack(spacing: 30) {
                SegmentedPickerView(
                    selection: $selected,
                    items: DemoType.allCases,
                    label: { $0.rawValue },
                    icon: { type in
                        switch type {
                        case .movies: return "film"
                        case .shows: return "tv"
                        }
                    }
                )
                .padding()
            }
            .frame(maxHeight: .infinity)
            .background(
                LinearGradient(colors: [.darkRed, .black], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
        }
    }

    return PreviewWrapper()
}
