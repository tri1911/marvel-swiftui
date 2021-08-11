//
//  MarvelApp.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-10.
//

import SwiftUI

@main
struct MarvelApp: App {
    @StateObject private var store = CharacterStore()
    
    var body: some Scene {
        WindowGroup {
            CharactersView()
                .environmentObject(store)
        }
    }
}
