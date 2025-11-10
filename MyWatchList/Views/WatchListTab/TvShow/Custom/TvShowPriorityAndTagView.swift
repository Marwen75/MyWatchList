//
//  TvShowPriorityAndTagView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 27/09/2025.
//

import SwiftUI

struct TvShowPriorityAndTagView: View {
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var tvShow: TvShow
    
    var body: some View {
#if os(iOS)
        Picker("Priority", selection: $tvShow.priority) {
            Label(tvShow.watched ? "Re-watch eventually" : "Watch later", systemImage: "eye.half.closed").tag(Int16(0))
            Label(tvShow.watched ? "Re-watch soon" : "Must watch", systemImage: "eye").tag(Int16(1))
            Label(tvShow.watched ? "Re-watch urgently" : "Watch urgently", systemImage: "eye.trianglebadge.exclamationmark").tag(Int16(2))
        }
        .onChange(of: tvShow.priority) {
            dataManager.save()
        }
        
        Menu {
            ForEach(tvShow.showTags) { tag in
                Button {
                    tvShow.removeFromTags(tag)
                    dataManager.save()
                } label: {
                    Label(tag.tagName, systemImage: "checkmark")
                }
            }
            
            let otherTags = dataManager.missingTags(from: tvShow)
            
            if !otherTags.isEmpty {
                Divider()
                
                Section("Add tags") {
                    ForEach(otherTags) { tag in
                        Button(tag.tagName) {
                            tvShow.addToTags(tag)
                            dataManager.save()
                        }
                    }
                }
            }
        } label: {
            Text(tvShow.showTagsList).underline()
                .multilineTextAlignment(.leading)
                .foregroundStyle(.yellow)
        }
        
#else
        HStack {
            Picker("", selection: $tvShow.priority) {
                Label("Watch later", systemImage: "eye.half.closed").tag(Int16(0))
                Label("Must watch", systemImage: "eye").tag(Int16(1))
                Label("Watch urgently", systemImage: "eye.trianglebadge.exclamationmark").tag(Int16(2))
            }
            .pickerStyle(.menu)
            .font(.subheadline)
            
            Spacer()
            
            Menu {
                ForEach(tvShow.showTags) { tag in
                    Button {
                        tvShow.removeFromTags(tag)
                        dataManager.save()
                    } label: {
                        Label(tag.tagName, systemImage: "checkmark")
                    }
                }
                
                let otherTags = dataManager.missingTags(from: tvShow)
                
                if !otherTags.isEmpty {
                    Divider()
                    
                    Section("Add tags") {
                        ForEach(otherTags) { tag in
                            Button(tag.tagName) {
                                tvShow.addToTags(tag)
                                dataManager.save()
                            }
                        }
                    }
                }
            } label: {
                Text(tvShow.showTagsList).underline()
                    .multilineTextAlignment(.leading)
            }
        }
#endif
    }
}

#Preview {
    TvShowPriorityAndTagView(tvShow: .example)
        .environmentObject(DataManager.preview)
}
