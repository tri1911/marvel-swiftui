//
//  ContentView.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-10.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "safari.fill")
                    Text("Discover")
                }
            
            Text("Characters")
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Characters")
                }
            
            Text("Comics")
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Comics")
                }
            
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
