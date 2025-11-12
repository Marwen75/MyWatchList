//
//  TypeOfSearchVIew.swift
//  MyWatchList
//
//  Created by Marwen Haouacine on 09/09/2025.
//

import SwiftUI

struct TypeOfSearchVIew: View {
    @ObservedObject var searchViewModel: SearchViewModel
    
    var body: some View {
        VStack {
            SegmentedPickerView(selection: $searchViewModel.selectedTypeOfContent, items: searchViewModel.typeOfContent,
                label: { type in
                    NSLocalizedString(type.rawValue, comment: "")
                }, icon: { type in
                    switch type {
                    case .movies: return "film"
                    case .shows:  return "tv"
                    }
                }
            )
            .padding([.leading, .trailing, .top])
            .onChange(of: searchViewModel.selectedTypeOfContent) {
                searchViewModel.tmdbContents = []
                searchViewModel.currentPage = 1
                
                if searchViewModel.searchText != "" {
                    Task {
                        await searchViewModel.search()
                    }
                }
            }
            
            TextField("Search", text: $searchViewModel.searchText,
                      prompt: searchViewModel.selectedTypeOfContent == .movies ? Text("Search movies") : Text("Search tv shows"))
            .colorScheme(.light)
            .padding([.leading, .trailing, .top])
            .textFieldStyle(.roundedBorder)
            .accessibilityIdentifier("searchField")
            .onSubmit {
                if !searchViewModel.tmdbContents.isEmpty {
                    searchViewModel.tmdbContents = []
                }
                if searchViewModel.currentPage != 1 {
                    searchViewModel.currentPage = 1
                }
                
                if searchViewModel.searchText != "" {
                    Task {
                        await searchViewModel.search()
                    }
                }
            }
            .onChange(of: searchViewModel.currentPage) {
                if searchViewModel.currentPage < searchViewModel.totalPages {
                    Task {
                        await searchViewModel.search()
                    }
                }
            }
#if os(macOS)
            .frame(width: 300)
#endif
        }
    }
}

#Preview {
    TypeOfSearchVIew(searchViewModel: SearchViewModel(dataManager: DataManager.preview, networkManager: NetworkManager(environment: .testing)))
}
