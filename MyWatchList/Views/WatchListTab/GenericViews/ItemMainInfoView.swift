//
//  ItemMainInfoView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 05/11/2025.
//

import SwiftUI

struct ItemMainInfoView<T: WatchableItem, ExtraContent: View>: View {
    @ObservedObject var item: T
    let extraContent: () -> ExtraContent
    
    init(item: T, @ViewBuilder extraContent: @escaping () -> ExtraContent) {
        self.item = item
        self.extraContent = extraContent
    }
    
    var body: some View {
        #if os(iOS)
        VStack(alignment: .leading, spacing: 15) {
            Label(item.itemCredits.count > 1 ? item.crewLabelPlural : item.crewLabelSingular, systemImage: "person.crop.square.badge.video")
            
            ItemCreditsView(item: item)
                .padding(.bottom, 8)
            
            Divider()
            
            extraContent()
            
            HStack {
                Spacer()
                Text(item.itemGenres)
                Spacer()
            }
            
            Divider()

            Text(item.itemOverview)
                .overviewStyle()
            
            Divider()
        }
        .infoStyle()
        #else
        VStack(alignment: .leading) {
            CustomDivider()
            
            Label(item.itemCredits.count > 1 ? item.crewLabelPlural : item.crewLabelSingular, systemImage: "person.crop.square.badge.video")
                .infoStyle()
            
            ItemCreditsView(item: item)
            
            VStack(spacing: 10) {
                CustomDivider()
                
                extraContent()
                
                CustomDivider()
                
                Text(item.itemGenres)
                
                CustomDivider()
                
                Text(item.itemOverview)
                
                CustomDivider()
            }
            .infoStyle()
        }
        #endif
    }
}

#Preview {
    ItemMainInfoView(item: Movie.example) {
        
    }
}
