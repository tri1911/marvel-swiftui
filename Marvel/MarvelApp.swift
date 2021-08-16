//
//  MarvelApp.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-10.
//

import SwiftUI

@main
struct MarvelApp: App {
    @StateObject private var store = MarvelStore()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(store)
        }
    }
}
