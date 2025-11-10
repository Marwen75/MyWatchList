//
//  MoviePriorityAndTagView.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 27/09/2025.
//

import SwiftUI

struct MoviePriorityAndTagView: View {
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var movie: Movie
    
    var body: some View {
        #if os(iOS)
        Picker("Watch Priority", selection: $movie.priority) {
            Label(movie.watched ? "Re-watch eventually" : "Watch later", systemImage: "eye.half.closed").tag(Int16(0))
            Label(movie.watched ? "Re-watch soon" : "Must watch", systemImage: "eye").tag(Int16(1))
            Label(movie.watched ? "Re-watch urgently" : "Watch urgently", systemImage: "eye.trianglebadge.exclamationmark").tag(Int16(2))
        }
        .foregroundStyle(.white)
        .onChange(of: movie.priority) {
            dataManager.save()
        }
        
        Menu {
            ForEach(movie.movieTags) { tag in
                Button {
                    movie.removeFromTags(tag)
                    dataManager.save()
                } label: {
                    Label(tag.tagName, systemImage: "checkmark")
                }
            }
            
            let otherTags = dataManager.missingTags(from: movie)
            
            if !otherTags.isEmpty {
                Divider()
                
                Section("Add tags") {
                    ForEach(otherTags) { tag in
                        Button(tag.tagName) {
                            movie.addToTags(tag)
                            dataManager.save()
                        }
                    }
                }
            }
        } label: {
            Text(movie.movieTagsList).underline()
                .multilineTextAlignment(.leading)
                .foregroundStyle(.yellow)
        }
        
        Toggle(movie.watched ? "Mark as unwatched" : "Mark as watched", isOn: $movie.watched)
            .foregroundStyle(.white)
            .tint(.yellow)
            .onChange(of: movie.watched, dataManager.save)
        
        
        #else
        HStack {
            Picker("", selection: $movie.priority) {
                Label("Watch later", systemImage: "eye.half.closed").tag(Int16(0))
                Label("Must watch", systemImage: "eye").tag(Int16(1))
                Label("Watch urgently", systemImage: "eye.trianglebadge.exclamationmark").tag(Int16(2))
            }
            .pickerStyle(.menu)
            .font(.subheadline)
            .onChange(of: movie.priority) {
                dataManager.save()
            }
            
            Spacer()
            
            Menu {
                ForEach(movie.movieTags) { tag in
                    Button {
                        movie.removeFromTags(tag)
                        dataManager.save()
                    } label: {
                        Label(tag.tagName, systemImage: "checkmark")
                    }
                }
                
                let otherTags = dataManager.missingTags(from: movie)
                
                if !otherTags.isEmpty {
                    Divider()
                    
                    Section("Add tags") {
                        ForEach(otherTags) { tag in
                            Button(tag.tagName) {
                                movie.addToTags(tag)
                                dataManager.save()
                            }
                        }
                    }
                }
            } label: {
                Text(movie.movieTagsList).underline()
                    .multilineTextAlignment(.leading)
            }
        }
        #endif
    }
}

#Preview {
    MoviePriorityAndTagView(movie: .example)
        .environmentObject(DataManager.preview)
}
