//
//  MarvelApp.swift
//  Marvel
//
//  Created by Elliot Ho on 2021-08-10.
//

import SwiftUI

@main
struct MarvelApp: App {
    let persistentController = PersistentController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentController.container.viewContext)
        }
    }
}
