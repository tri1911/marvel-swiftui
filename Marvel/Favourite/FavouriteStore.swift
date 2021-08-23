//
//  FavouriteStore.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-22.
//

import SwiftUI

class FavouriteStore: ObservableObject {
    @Published private var favourites = [String:Set<Int>]()
    
    private let favouritesKey = "Marvel.Favorites"
    
    init() {
        // Load saved data
        if let data = UserDefaults.standard.data(forKey: favouritesKey), let favourites = try? JSONDecoder().decode([String:Set<Int>].self, from: data) {
            self.favourites = favourites
        } else {
            favourites = [:]
        }
    }
    
    // Return true if the favourite set contains this character
    func contains<Info>(_ info: Info) -> Bool where Info: Identifiable, Info.ID == Int {
        favourites[String(describing: Info.self)]?.contains(info.id) ?? false // Or type(of: info)
    }
    
    func add<Info>(_ info: Info) where Info: Identifiable, Info.ID == Int {
        // objectWillChange.send()
        // Add the character to the favourite set
        favourites[String(describing: Info.self)]?.insert(info.id)
        // Save the change
        save()
    }

    func remove<Info>(_ info: Info) where Info: Identifiable, Info.ID == Int {
        // objectWillChange.send()
        // Remove the character from the favourite set
        favourites[String(describing: Info.self)]?.remove(info.id)
        // Save the change
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(favourites) {
            UserDefaults.standard.set(data, forKey: favouritesKey)
        }
    }
}
