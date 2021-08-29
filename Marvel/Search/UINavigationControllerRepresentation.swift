//
//  UINavigationControllerRepresentation.swift
//  Marvel
//
//  Created by Elliot Ho.
//

import SwiftUI

struct UINavigationControllerRepresentation<Content>: UIViewControllerRepresentable where Content: View {
    @Binding var selectedScope: Int
    @Binding var searchText: String
    
    var scopeSearch: [String]?
    
    @ViewBuilder
    var content: () -> Content
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedScope: $selectedScope, searchText: $searchText)
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        // The root view controller which is the integrated SwiftUI View within a UIKit View Hierarchy
        let rootViewController = UIHostingController(rootView: content())
        
        // UIKit Search Controller
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = scopeSearch
        
        // Use the coordinator to forward delegate messages from the search bar to SwiftUI.
        searchController.searchBar.delegate = context.coordinator
        searchController.searchBar.placeholder = "Characters, Comics, Series, and More"
        
        // UIKit's Navigation Controller
        let navigationController = UINavigationController(rootViewController: rootViewController)
        let navigationBar = navigationController.navigationBar
        navigationBar.prefersLargeTitles = true
        navigationBar.topItem?.title = "Search"
        navigationBar.topItem?.searchController = searchController
        
        // Make the search bar always visible.
        navigationBar.topItem?.hidesSearchBarWhenScrolling = false
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    class Coordinator: NSObject, UISearchBarDelegate, UISearchControllerDelegate {
        @Binding var searchText: String
        @Binding var selectedScope: Int

        init(selectedScope: Binding<Int>, searchText: Binding<String>) {
            _selectedScope = selectedScope
            _searchText = searchText
        }

        // MARK: - Search Bar Delegation

        // Update the search text in SwiftUI via the searchText Binding.
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.searchText = searchText
        }

        // Update the selected scope value in SwiftUI via the selectedScope Binding.
        func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
            self.selectedScope = selectedScope
        }
        
        // Reset the search bar to empty when the Cancel button is clicked
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchText = ""
        }
    }
}
