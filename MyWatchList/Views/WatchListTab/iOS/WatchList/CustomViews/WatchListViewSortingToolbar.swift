//
//  WatchListViewSortingToolbar.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 07/11/2025.
//

import SwiftUI

struct WatchListViewSortingToolbar: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        Menu {
            Text("Sort your content:")
            
            Divider()
            
            Picker("Sort by", selection: $dataManager.sortOrder) {
                ForEach(DataManager.SortOrder.allCases) { order in
                    Text(order.label).tag(order)
                }
            }
        } label: {
            switch dataManager.sortOrder {
            case .priority:
                Image(systemName: "eye.circle")
            case .title:
                Image(systemName: "character.magnify")
            }
        }
    }
}

#Preview {
    WatchListViewSortingToolbar()
        .environmentObject(DataManager.preview)
}
