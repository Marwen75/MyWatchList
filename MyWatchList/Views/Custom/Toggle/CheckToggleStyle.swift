//
//  CheckToggleStyle.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 03/11/2025.
//

import SwiftUI

struct CheckToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack {
                configuration.label
                Spacer()
                Image(systemName: configuration.isOn ? "calendar.badge.checkmark" : "calendar.badge.plus")
                    .foregroundStyle(configuration.isOn ? .yellow : .gray)
                    .imageScale(.large)
            }
        }
        .buttonStyle(.plain)
    }
}
